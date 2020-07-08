import json
import re
from itertools import chain

import mwapi
import mwbase

from .content_transformer import ContentTransformer


class Wikidata2Words(ContentTransformer):

    def __init__(self, ordered_pids=None):
        ordered_pids = ordered_pids if ordered_pids is not None else []
        self.pid_order_map = {pid: i for i, pid in enumerate(ordered_pids)}

    @classmethod
    def from_siteinfo(cls, siteinfo, *args, **kwargs):
        session = mwapi.Session(
            "https:" + siteinfo['general']['server'],
            "Wikidata2Words transformer")
        doc = session.get(
            action="parse",
            page="MediaWiki:Wikibase-SortedProperties",
            prop="wikitext")
        wikitext = doc['parse']['wikitext']['*']
        ordered_pids = re.findall('P[0-9]+', wikitext)
        return cls(ordered_pids, *args, **kwargs)

    def transform(self, content):
        doc = json.loads(content)
        entity = mwbase.Entity.from_json(doc)
        claims_tuples = list(self._extract_property_values(entity))
        if self.instanceof_nonzero_namespace(claims_tuples):
            return None
        claims_tuples.sort(key=self.get_claim_pid_index)
        return list(chain(*claims_tuples))

    def get_claim_pid_index(self, claims_tuple):
        pid = claims_tuple[0]
        return self.pid_order_map.get(pid, len(self.pid_order_map))

    def instanceof_nonzero_namespace(self, claims_tuples):
        namespace_QIDs = ['Q4167836', 'Q11266439', 'Q4663903']
        return any((claims_tuple[0] == 'P31' and
                    claims_tuple[1] in namespace_QIDs)
                   for claims_tuple in claims_tuples)

    @staticmethod
    def _extract_property_values(entity):
        properties = list(entity.properties.keys())
        for prop in properties:
            value_found = False
            for statement in entity.properties[prop]:
                claim = statement.claim
                if claim.datavalue is not None and \
                   claim.datavalue.type == 'wikibase-entityid':
                    datavalue = claim.datavalue
                    if datavalue:
                        value = datavalue.id
                        value_found = True
                        yield (prop, value)

            if not value_found:
                yield (prop,)
