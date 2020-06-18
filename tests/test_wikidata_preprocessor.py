from mwtext import WikidataPreprocessor
import json
import mwbase


def test_wikidata_preprocessing():
    wdpp = WikidataPreprocessor()
    item = """
{"type":"item","id":"Q1082","labels":{"de":{"language":"de","value":"Sons of Nature"},"en":{"language":"en","value":"Sons of Nature"},"fr":{"language":"fr","value":"Sons of Nature"},"es":{"language":"es","value":"Sons of Nature"},"it":{"language":"it","value":"Sons of Nature"},"hu":{"language":"hu","value":"Sons of Nature"},"ru":{"language":"ru","value":"Sons of Nature"},"ta":{"language":"ta","value":"\u0b9a\u0ba9\u0bcd\u0bb8\u0bcd \u0b86\u0b83\u0baa\u0bcd \u0ba8\u0bc7\u0b9a\u0bcd\u0b9a\u0bb0\u0bcd"},"ca":{"language":"ca","value":"Sons of Nature"},"oc":{"language":"oc","value":"Sons of Nature"},"nb":{"language":"nb","value":"Sons of Nature"},"nl":{"language":"nl","value":"Sons of Nature"}},"descriptions":{"de":{"language":"de","value":"Schweizer Musikprojekt"},"en":{"language":"en","value":"Swiss musical project"},"fr":{"language":"fr","value":"projet musical"},"es":{"language":"es","value":"grupo musical suizo"},"it":{"language":"it","value":"gruppo musicale svizzero"},"fa":{"language":"fa","value":"\u06cc\u06a9 \u067e\u0631\u0648\u0698\u0647 \u0645\u0648\u0633\u06cc\u0642\u06cc \u0633\u0648\u0626\u06cc\u0633\u06cc"},"ru":{"language":"ru","value":"\u0448\u0432\u0435\u0434\u0441\u043a\u0438\u0439 \u043c\u0443\u0437\u044b\u043a\u0430\u043b\u044c\u043d\u044b\u0439 \u043f\u0440\u043e\u0435\u043a\u0442"},"hu":{"language":"hu","value":"sv\u00e1jci zeneprojekt"},"ne":{"language":"ne","value":"\u0938\u094d\u0935\u093f\u0938 \u0938\u0902\u0917\u0940\u0924 \u092a\u0930\u093f\u092f\u094b\u091c\u0928\u093e"}},"aliases":[],"claims":{"P31":[{"mainsnak":{"snaktype":"value","property":"P31","hash":"0582a99249c95258cb4fb67d01eab9f71d16ce69","datavalue":{"value":{"entity-type":"item","numeric-id":2707384,"id":"Q2707384"},"type":"wikibase-entityid"}},"type":"statement","id":"Q1082$5fc3f871-4a71-513c-f3ad-bb96131dc46e","rank":"normal"}],"P495":[{"mainsnak":{"snaktype":"value","property":"P495","hash":"422a58500b1839ec32e81a6786378211dd00ac50","datavalue":{"value":{"entity-type":"item","numeric-id":39,"id":"Q39"},"type":"wikibase-entityid"}},"type":"statement","id":"Q1082$E4269462-AFEA-4715-B320-7E9936DFEAEE","rank":"normal"}]},"sitelinks":{"dewiki":{"site":"dewiki","title":"Sons of Nature","badges":[]}}}
"""
    item_doc = json.loads(item)
    entity = mwbase.Entity.from_json(item_doc)
    assert wdpp.process(entity) == [('P31', 'Q2707384'), ('P495', 'Q39')]
