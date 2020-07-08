import json

import mwbase


def include(page, revision):
    # Namespace zero
    if page.namespace != 0 or revision.model != 'wikibase-item':
        return False

    item_doc = json.loads(revision.text)
    qid = item_doc.get('id', None)
    redirect = item_doc.get('redirect')
    entity = mwbase.Entity.from_json(item_doc)

    # Has a Qid
    if qid is None:
        return False

    # Redirects to other Wikidata item
    if redirect is not None:
        return False

    # Sitelinks to a Wikipedia of any language
    return any((llink not in ('commonswiki', 'specieswiki',
                'metawiki', 'testwiki') and
                llink.endswith("wiki"))
               for llink in entity.sitelinks)
