# Remove target files after command failure.
#.DELETE_ON_ERROR:

dump_dir=/mnt/data/xmldatadumps/public
dump_date=20201201
vector_dimensions=50
qt_cutoff=10000
vector_params=--param 'dim=$(vector_dimensions)' --param 'loss="ova"' --qt-cutoff=$(qt_cutoff)
vocab_str=10k

preprocessed_article_text: \
		datasets/arwiki-$(dump_date)-plaintext.w_labels.txt \
		datasets/cswiki-$(dump_date)-plaintext.w_labels.txt \
		datasets/enwiki-$(dump_date)-plaintext.w_labels.txt \
		datasets/euwiki-$(dump_date)-plaintext.w_labels.txt \
		datasets/huwiki-$(dump_date)-plaintext.w_labels.txt \
		datasets/hywiki-$(dump_date)-plaintext.w_labels.txt \
		datasets/jawiki-$(dump_date)-plaintext.w_labels.txt \
		datasets/kowiki-$(dump_date)-plaintext.w_labels.txt \
		datasets/srwiki-$(dump_date)-plaintext.w_labels.txt \
		datasets/ukwiki-$(dump_date)-plaintext.w_labels.txt \
		datasets/viwiki-$(dump_date)-plaintext.w_labels.txt \
		datasets/wikidata-$(dump_date)-plaintext.w_labels.txt \
		datasets/zhwiki-$(dump_date)-plaintext.w_labels.txt

learned_vectors: \
		datasets/arwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/cswiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/enwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/euwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/huwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/hywiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/jawiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/kowiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/srwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/ukwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/viwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/wikidata-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2 \
		datasets/zhwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2


gensim_vectors: \
		datasets/arwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/cswiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/enwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/euwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/huwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/hywiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/jawiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/kowiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/srwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/ukwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/viwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/wikidata-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv \
		datasets/zhwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv


datasets/enwiki.labeled_article_items.json.bz2:
	wget https://analytics.wikimedia.org/published/datasets/archive/public-datasets/all/ores/topic/enwiki-20191201-labeled_article_items.json.bz2 -qO- > $@


###################### Arabic Wikipedia ##########################

datasets/arwiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/arwiki/$(dump_date)/arwiki-$(dump_date)-pages-articles[!-]*.xml-*.bz2 \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://ar.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/arwiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/arwiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang ar > $@

datasets/arwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/arwiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/arwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/arwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@


###################### Czech Wikipedia ##########################

datasets/cswiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/cswiki/$(dump_date)/cswiki-$(dump_date)-pages-articles.xml.bz2 \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://cs.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/cswiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/cswiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang cs > $@

datasets/cswiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/cswiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/cswiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/cswiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@


###################### English Wikipedia ##########################

datasets/enwiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/enwiki/$(dump_date)/enwiki-$(dump_date)-pages-articles[!-]*.xml-*.bz2 \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://en.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/enwiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/enwiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang en > $@

datasets/enwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/enwiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/enwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/enwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@


###################### Basque Wikipedia ##########################

datasets/euwiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/euwiki/$(dump_date)/euwiki-$(dump_date)-pages-articles.xml.bz2 \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://eu.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/euwiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/euwiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang eu > $@

datasets/euwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/euwiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/euwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/euwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@


###################### Hungarian Wikipedia ##########################

datasets/huwiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/huwiki/$(dump_date)/huwiki-$(dump_date)-pages-articles[!-]*.xml-*.bz2 \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://hu.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/huwiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/huwiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang hu > $@

datasets/huwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/huwiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/huwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/huwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@


###################### Armenian Wikipedia ##########################

datasets/hywiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/hywiki/$(dump_date)/hywiki-$(dump_date)-pages-articles.xml.bz2 \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://hy.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/hywiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/hywiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang hy > $@

datasets/hywiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/hywiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/hywiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/hywiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@


###################### Korean Wikipedia ##########################

datasets/kowiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/kowiki/$(dump_date)/kowiki-$(dump_date)-pages-articles[!-]*.xml-*.bz2 \
         --param 'tok_strategy="CJK"' \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://ko.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/kowiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/kowiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang ko > $@

datasets/kowiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/kowiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/kowiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/kowiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@


###################### Serbian Wikipedia ##########################

datasets/srwiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/srwiki/$(dump_date)/srwiki-$(dump_date)-pages-articles.xml.bz2 \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://sr.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/srwiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/srwiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang sr > $@

datasets/srwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/srwiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/srwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/srwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@


###################### Ukranian Wikipedia ##########################

datasets/ukwiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/ukwiki/$(dump_date)/ukwiki-$(dump_date)-pages-articles[!-]*.xml-*.bz2 \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://uk.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/ukwiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/ukwiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang uk > $@

datasets/ukwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/ukwiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/ukwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/ukwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@


###################### Japanese Wikipedia ##########################


datasets/jawiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/jawiki/$(dump_date)/jawiki-$(dump_date)-pages-articles[!-]*.xml-*.bz2 \
         --param 'tok_strategy="CJK"' \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://ja.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/jawiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/jawiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang ja > $@

datasets/jawiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/jawiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/jawiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/jawiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@

###################### Chinese Wikipedia ##########################


datasets/zhwiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/zhwiki/$(dump_date)/zhwiki-$(dump_date)-pages-articles[!-]*.xml-*.bz2 \
	 --param 'tok_strategy="CJK"' \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://zh.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/zhwiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/zhwiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang zh > $@

datasets/zhwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/zhwiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/zhwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/zhwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@

###################### Vietnamese Wikipedia ##########################

datasets/viwiki-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikitext2Words $(dump_dir)/viwiki/$(dump_date)/viwiki-$(dump_date)-pages-articles[!-]*.xml-*.bz2 \
	 --namespace 0 \
	 --min-content-length 200 \
	 --wiki-host https://vi.wikipedia.org \
	 --debug | bzip2 -c > $@

datasets/viwiki-$(dump_date)-plaintext.w_labels.txt: \
		datasets/viwiki-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang vi > $@

datasets/viwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/viwiki-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/viwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/viwiki-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@


######################### Wikidata #################################


datasets/wikidata-$(dump_date)-revdocs-with-words.json.bz2:
	./utility transform_content Wikidata2Words $(dump_dir)/wikidatawiki/$(dump_date)/wikidatawiki-$(dump_date)-pages-articles[!-]*.xml-*.bz2 \
	 --namespace 0 \
	 --min-content-length 0 \
	 --wiki-host https://www.wikidata.org \
	 --include wikidata_items_with_wikipedia_sitelinks \
	 --debug | bzip2 -c > $@

datasets/wikidata-$(dump_date)-plaintext.w_labels.txt: \
		datasets/wikidata-$(dump_date)-revdocs-with-words.json.bz2 \
		datasets/enwiki.labeled_article_items.json.bz2
	bzcat $< | ./utility words2plaintext \
	 --labels datasets/enwiki.labeled_article_items.json.bz2 \
	 --title-lang wikidata > $@

datasets/wikidata-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2: \
		datasets/wikidata-$(dump_date)-plaintext.w_labels.txt
	./utility learn_vectors $^ $(vector_params) | bzip2 -c > $@

datasets/wikidata-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.$(vocab_str).kv: \
		datasets/wikidata-$(dump_date)-learned_vectors.$(vector_dimensions)_cell.vec.bz2
	./utility word2vec2gensim $^ $@
