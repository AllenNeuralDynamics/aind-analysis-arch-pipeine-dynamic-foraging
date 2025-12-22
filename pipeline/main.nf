#!/usr/bin/env nextflow
// hash:sha256:e4f9931f14b617d413501668dae4f5d6f0fe34652fff1c94ecbf767d0dd20b08

nextflow.enable.dsl = 1

params.foraging_nwb_bonsai_url = 's3://aind-behavior-data/foraging_nwb_bonsai'

foraging_nwb_bonsai_to_han_prod_aind_analysis_arch_job_manager_1 = channel.fromPath(params.foraging_nwb_bonsai_url + "/", type: 'any')
capsule_han_debug_aind_analysis_arch_job_manager_v_2_1_to_capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_2 = channel.create()
capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_to_capsule_han_debug_aind_analysis_arch_upload_db_s_3_v_2_3_3 = channel.create()

// capsule - han_prod_aind-analysis-arch-job-manager
process capsule_han_debug_aind_analysis_arch_job_manager_v_2_1 {
	tag 'capsule-7174758'
	container "$REGISTRY_HOST/capsule/ee18ab31-9a75-4a2a-9647-5a89b5ea24d4:c518114da78e633cd28b0a99f1a04398"

	cpus 1
	memory '7.5 GB'

	input:
	path 'capsule/data/foraging_nwb_bonsai' from foraging_nwb_bonsai_to_han_prod_aind_analysis_arch_job_manager_1.collect()

	output:
	path 'capsule/results/*' into capsule_han_debug_aind_analysis_arch_job_manager_v_2_1_to_capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_2

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=ee18ab31-9a75-4a2a-9647-5a89b5ea24d4
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7174758.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7174758.git" capsule-repo
	fi
	git -C capsule-repo checkout f58df8bfc5c45093900a3165226fd13e147690c3 --quiet
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_han_debug_aind_analysis_arch_job_manager_v_2_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - han_debug_aind-analysis-arch-job-wrapper-dynamic-foraging
process capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2 {
	tag 'capsule-7135734'
	container "$REGISTRY_HOST/capsule/451da157-6f12-4d8e-970f-75a836b046fc:9c696e0eab1affdc9f3d42125edb6279"

	cpus 2
	memory '15 GB'

	publishDir "$RESULTS_PATH/$index", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/jobs' from capsule_han_debug_aind_analysis_arch_job_manager_v_2_1_to_capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_2.flatten()
	val index from 1..100000

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_to_capsule_han_debug_aind_analysis_arch_upload_db_s_3_v_2_3_3

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=451da157-6f12-4d8e-970f-75a836b046fc
	export CO_CPUS=2
	export CO_MEMORY=16106127360

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7135734.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7135734.git" capsule-repo
	fi
	git -C capsule-repo checkout a6ca0272a9993100cbd2e7aca9795bbb45395e25 --quiet
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - han_debug_aind-analysis-arch-upload-db-s3
process capsule_han_debug_aind_analysis_arch_upload_db_s_3_v_2_3 {
	tag 'capsule-6611699'
	container "$REGISTRY_HOST/capsule/25a3c40a-7947-402d-899b-0cc2c8f88f6c:cde317e728dcd01a472d8e3bea6488d6"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH/$index", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_to_capsule_han_debug_aind_analysis_arch_upload_db_s_3_v_2_3_3
	val index from 1..100000

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=25a3c40a-7947-402d-899b-0cc2c8f88f6c
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6611699.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6611699.git" capsule-repo
	fi
	git -C capsule-repo checkout 2563ac8776ab2c4c73fbf3f9afebc2a3445f3731 --quiet
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
