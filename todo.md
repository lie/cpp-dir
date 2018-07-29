# ToDo

- getter, setter を自動生成するスクリプトの作成
	- 以下を参考にする
		- `p/library/generate-getter-setter.sh`
		- `p/library/generate-getter-setter-prototype.sh`
	- シェルスクリプトを置く場所
		- `./script/` ?
	- 仕様
		- オプションで以下を選択できるようにする？
			- `varaible delaration in hpp -> accessor in cpp`
			- `accessor in cpp -> accessor prototype declaration in hpp`
		- output
			- ターミナルに標準出力
			- クリップボードに格納
				- pbcopy(macOS)
