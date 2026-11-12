# will add the license headers to all of our files
# requires go installed in your system: https://golang.org/doc/install
addheaders:
	@which addlicense > /dev/null || go get -u github.com/google/addlicense
	@addlicense -c "The Open Workflow Specification Authors" -l apache .