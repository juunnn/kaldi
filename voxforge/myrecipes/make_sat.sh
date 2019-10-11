#!/bin/bash

### MAKE SPEAKER A T ###

source ./cmd.sh || exit 1;
source ./path.sh || exit 1;
source parse_options.sh || exit ;


dir_exp="./exp/sat"
dir_ali="./exp/lda/align"

if [ ! -d $dir_ali ]; then
	./steps/align_si.sh --nj $njobs --cmd "$train_cmd" --use-graphs true \
		data/train data/lang ./exp/lda/model ${dir_ali}
fi

./steps/train_sat.sh --cmd "$train_cmd" \
	$leaves $gauss \
	data/train data/lang ${dir_ali} \
	${dir_exp}/model

./utils/mkgraph.sh data/lang_test ${dir_exp}/model ${dir_exp}/graph

./steps/decode_fmllr.sh --config conf/decode.config --nj $njobs --cmd "$decode_cmd" \
	${dir_exp}/graph data/test ${dir_exp}/model/decode
