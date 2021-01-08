.PHONY=default env slides clear-notebook push evil-push clean

.DEFAULT_GOAL=default

PY=python3

PY_ENV=.venv/bin/python
PIP_ENV=.venv/bin/pip
JUPYTER=.venv/bin/jupyter

INTRO_BASIC=intro_to_python_basic
INTRO_BASIC_NB=$(INTRO_BASIC).ipynb
INTRO_BASIC_NB_OUT=$(INTRO_BASIC).out.ipynb
INTRO_BASIC_HTML=$(INTRO_BASIC).html

INTRO_TOOLS=intro_to_python_tools
INTRO_TOOLS_NB=$(INTRO_TOOLS).ipynb
INTRO_TOOLS_NB_OUT=$(INTRO_TOOLS).out.ipynb
INTRO_TOOLS_HTML=$(INTRO_TOOLS).html

INTRO_PANDAS=intro_to_python_pandas
INTRO_PANDAS_NB=$(INTRO_PANDAS).ipynb
INTRO_PANDAS_NB_OUT=$(INTRO_PANDAS).out.ipynb
INTRO_PANDAS_HTML=$(INTRO_PANDAS).html


default:
	@echo "Please select a valid target"


env:
	@test -d .venv || $(PY) -m venv .venv && $(PIP_ENV) install wheel
	$(PIP_ENV) install -r requirements.txt


slides-basic:
	$(JUPYTER) nbconvert $(INTRO_BASIC_NB) --to slides --execute
	mv $(INTRO_BASIC).slides.html $(INTRO_BASIC_HTML)
	$(PY_ENV) -m prepare_html --in $(INTRO_BASIC_HTML)


slides-tools:
	$(JUPYTER) nbconvert $(INTRO_TOOLS_NB) --to slides --execute
	mv $(INTRO_TOOLS).slides.html $(INTRO_TOOLS_HTML)
	$(PY_ENV) -m prepare_html --in $(INTRO_TOOLS_HTML)


slides-pandas:
	$(JUPYTER) nbconvert $(INTRO_PANDAS_NB) --to slides --execute
	mv $(INTRO_PANDAS).slides.html $(INTRO_PANDAS_HTML)
	$(PY_ENV) -m prepare_html --in $(INTRO_PANDAS_HTML)


slides: slides-basic slides-tools slides-pandas


clear-notebook:
	$(JUPYTER) nbconvert --clear-output $(INTRO_BASIC_NB)
	$(JUPYTER) nbconvert --clear-output $(INTRO_TOOLS_NB)
	$(JUPYTER) nbconvert --clear-output $(INTRO_PANDAS_NB)


push: slides clear-notebook
	git add .
	git commit -am "Update"
	git push


evil-push: slides clear-notebook
	rm -rf .git
	git init
	git checkout -b main
	git add .
	git commit -m "Initial commit"
	git remote add origin https://github.com/albert-rz/intro_to_python.git
	git push -u --force origin main


clean: clear-notebook
	rm -rf *.html
	rm -rf .ipynb_checkpoints __pycache__
