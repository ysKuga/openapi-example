# help について
# https://ktrysmt.github.io/blog/write-useful-help-command-by-shell/
.DEFAULT_GOAL := help

openapi-generate/basic: ## OpenAPI の生成 (basic) openapi-generated/basic/ 配下に作成
	sh scripts/openapi/generate.sh basic `pwd`/openapi-generated/basic

.PHONY: openapi2aspida/basic # コマンド名と同一ディレクトリがある場合の指定
openapi2aspida/basic: ## openapi2aspida を使用して aspida のコードを生成
	rm -rf openapi2aspida/basic/
	npx openapi2aspida -i openapi-generated/basic/generated/openapi/openapi.yaml -o openapi2aspida/basic

help: ## print this message
	@echo "Example operations by makefile."
	@echo ""
	@echo "Usage: make SUB_COMMAND argument_name=argument_value"
	@echo ""
	@echo "Command list:"
	@echo ""
	@printf "\033[36m%-30s\033[0m %-50s %s\n" "[Sub command]" "[Description]" "[Example]"
	@grep -E '^[/a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | perl -pe 's%^([/a-zA-Z_-]+):.*?(##)%$$1 $$2%' | awk -F " *?## *?" '{printf "\033[36m%-30s\033[0m %-50s %s\n", $$1, $$2, $$3}'
