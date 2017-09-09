target = $(blog_page)

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
	@echo "Now copy the files to the web server; this isn't it."
	scp blog.html freebsd@cnadocs.com:

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

#
# I hate to hard-code this path, because the resulting functionality only
# works for repositories underneath my `github' directory, but trying to
# make automation too intelligent violates the YAGNI principle and I have
# a thesis to write.
#

github_repository_level = ~/thesis/github

include common.mk

