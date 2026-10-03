APP=monApp
ROOT=./
PYTHON=~/venv/bin/python

.PHONY: venv
venv:
	python -m venv venv
	chmod +x venv/bin/activate
	./venv/bin/activate
	echo "source venv/bin/activate"

.PHONY: install_pipdep
install_pipdep:
	set -eux
	pip install -r requirements.txt
	django-admin --version

.PHONY: format
format:
	set -eux
	isort -v $(ROOT)$(APP) || true
	autopep8 -v -i -r -j 4 -p 10 -a --max-line-length 120 $(ROOT)$(APP) || true # --experimental

.PHONY: tests
tests:
	$(PYTHON) $(ROOT)manage.py test --verbosity 2 --force-color $(APP)/tests/ || true

.PHONY: coverage
coverage:
	coverage run --source="$(APP)" manage.py test --verbosity 2 --force-color $(ROOT)$(APP)/tests/
	coverage report 
	coverage html

.PHONY: all
all: Dcheck format coverage

.PHONY: make_superuser
make_superuser:
	$(PYTHON) $(ROOT)manage.py createsuperuser

.PHONY: Dshell
Dshell:
	$(PYTHON) $(ROOT)manage.py shell

.PHONY: run
run:
	$(PYTHON) $(ROOT)manage.py runserver

.PHONY: DmakeMCD
DmakeMCD:
	$(PYTHON) $(ROOT)manage.py graph_models -a -o mcd.png

.PHONY: Dmakemigrate
Dmakemigrate:
	$(PYTHON) $(ROOT)manage.py makemigrations $(APP)

.PHONY: Dsqlmigrate
Dsqlmigrate:
	@echo $(PYTHON) $(ROOT)manage.py sqlmigrate $(APP) $(sql)

.PHONY: Ddomigrate
Ddomigrate:
	$(PYTHON) $(ROOT)manage.py migrate

.PHONY: Dmigtot
Dmigtot:
	set -x
	for i in $(seq 1 6); do \
		$(PYTHON) $(ROOT)manage.py sqlmigrate $(APP) $$i; \
	done;

.PHONY: Dmig
Dmig: Dmakemigrate Dmigtot Ddomigrate

.PHONY: Dcheck
Dcheck:
	$(PYTHON) $(ROOT)manage.py check

.PHONY: clean
clean:
	@echo "Cleaning up..."
	# @echo "deactivate" || true
	# @echo "rm -rv ./venv"  || true
	find $(ROOT) -type d -name .mypy_cache | xargs rm -rv || true
	find $(ROOT) -type d -name .pytest_cache | xargs rm -rv || true
	find $(ROOT) -type d -name __pycache__ | xargs rm -rv || true
	find $(ROOT) -type f -name "*.pyc" | xargs rm -rv || true
	find $(ROOT) -type d -name instance | xargs rm -rv || true
	find $(ROOT) -type d -name htmlcov | xargs rm -rv || true
	@echo "Cleaning up done"