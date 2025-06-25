all: slides zip sync

slides:
	jupyter-nbconvert **/L*.ipynb  --to slides  --SlidesExporter.reveal_theme=solarized --SlidesExporter.reveal_scroll=True --SlidesExporter.reveal_transition=fade

html:
	jupyter-nbconvert **/**.ipynb  --to html

zip:
	git archive --output=python-slides.zip HEAD

sync:
	rsync -Cav --delete-excluded --prune-empty-dirs --exclude='.*' --include '*/' --include '*.ipynb' --include '*slides.zip' --include '*.slides.html' --include '*.pdf' --include 'figures/*'  --exclude '*' .  ${HOME}/nextcloud/feng.li/python/
