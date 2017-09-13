target = $(blog_page)

include ../notes.new/private_for_cnadocs.com.mk

css_file = style.css
scheme_file = index.scm
unicode_test = unicode_font_test_page.html
todo_file = TODO.txt

security_page = security/security.html
company_page = company.html
404_page = 404.html
blog_page = blog.html

build_counter = build_counter.txt

build_number_value = $(shell cat ${build_counter})

temporary_files = *.bak consolidated_bibtex_file.bib

.PHONY : security # there's a directory named security, so we need this

all::
	sed -i .backup \
		's/\(<\!-- BUILD NUMBER -->Build\) [0-9]*/\1 $(build_number_value)/g' \
		$(blog_page)
	sed -i .backup \
		's/\(<\!-- BUILD NUMBER -->Build\) [0-9]*/\1 $(build_number_value)/g' \
		$(company_page)
	sed -i .backup \
		's/\(<\!-- BUILD NUMBER -->Build\) [0-9]*/\1 $(build_number_value)/g' \
		$(security_page)
	sed -i .backup \
		's/\(<\!-- BUILD NUMBER -->Build\) [0-9]*/\1 $(build_number_value)/g' \
		$(404_page)
	@echo $$(($$(cat $(build_counter)) + 1)) > $(build_counter)
	make commit
	make upload

upload: $(target)
	scp $< $(private_web_server_for_cnadocs):
	ssh -t $(private_web_server_for_cnadocs) sudo mv $< www
	ssh -t $(private_web_server_for_cnadocs) sudo chown www:www www/$<
	ssh -t $(private_web_server_for_cnadocs) ls -l www/$<

ssh:
	ssh $(private_web_server_for_cnadocs)

clean::
	rm -fv $(temporary_files)

vi:
	vi $(target)

unicode:
	vi $(unicode_test)

css: style

style:
	vi $(css_file)

security:
	vi $(security_page)

404:
	vi $(404_page)

company:
	vi $(company_page)

blog:
	vi $(blog_page)

todo:
	vi $(todo_file)

spell::
	aspell --lang=en_GB -H check $(blog_page)
	aspell --lang=en_GB -H check $(security_page)
	aspell --lang=en_GB -H check robots.txt
	aspell --lang=en_GB -H check humans.txt
	aspell --lang=en_GB -H check hackers.txt
	aspell --lang=en_GB -H check $(company_page)
	aspell --lang=en_GB -H check $(404_page)


include common.mk

