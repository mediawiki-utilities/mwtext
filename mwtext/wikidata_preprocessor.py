import json
import requests
import re


class WikidataPreprocessor:
    def process(self, entity):
        return list(self._extract_property_values(entity))

    @staticmethod
    def _extract_property_values(entity):
        properties = list(entity.properties.keys())
        for prop in properties:
            value_found = False
            for statement in entity.properties[prop]:
                claim = statement.claim
                if claim.datavalue is not None and claim.datavalue.type == 'wikibase-entityid':
                    value = claim.datavalue.id
                    value_found = True
                    yield (prop, value)

            if not value_found:
                yield (prop,)


    def get_sorted_properties(self):
        session = requests.Session()
        URL = "https://www.wikidata.org/w/api.php"
        PARAMS = {
            "action": "parse",
            "page" : "MediaWiki:Wikibase-SortedProperties",
            "prop": "wikitext",
            "format": "json"
            }
        DATA = session.get(url=URL, params=PARAMS).json()
        WIKITEXT = DATA['parse']['wikitext']['*']
        PIDs = re.findall( 'P[0-9]+', WIKITEXT)
        return PIDs

