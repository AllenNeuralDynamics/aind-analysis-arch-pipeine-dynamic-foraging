#!/usr/bin/env nextflow
// hash:sha256:25318de7f71a9f48a0eb89400296e7daeee810efdc782df7223fb719a9800c02

nextflow.enable.dsl = 1

params.foraging_nwb_bonsai_url = 's3://aind-behavior-data/foraging_nwb_bonsai'

foraging_nwb_bonsai_to_han_debug_aind_analysis_arch_job_manager_v2_1 = channel.fromPath(params.foraging_nwb_bonsai_url + "/", type: 'any')
capsule_han_debug_aind_analysis_arch_job_manager_v_2_1_to_capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_2 = channel.create()
capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_to_capsule_han_debug_aind_analysis_arch_upload_db_s_3_v_2_3_3 = channel.create()

// capsule - han_debug_aind-analysis-arch-job-manager-v2
process capsule_han_debug_aind_analysis_arch_job_manager_v_2_1 {
	tag 'capsule-7174758'
	container "$REGISTRY_HOST/capsule/ee18ab31-9a75-4a2a-9647-5a89b5ea24d4:89106f7107e98e91487940ff623a07a5"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/foraging_nwb_bonsai' from foraging_nwb_bonsai_to_han_debug_aind_analysis_arch_job_manager_v2_1.collect()

	output:
	path 'capsule/results/*' into capsule_han_debug_aind_analysis_arch_job_manager_v_2_1_to_capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_2

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=ee18ab31-9a75-4a2a-9647-5a89b5ea24d4
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7174758.git" capsule-repo
	git -C capsule-repo checkout 329310347652f2b33102c7357ffb753699573d85 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_han_debug_aind_analysis_arch_job_manager_v_2_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - han_debug_aind-analysis-arch-job-wrapper-dynamic-foraging-v2
process capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2 {
	tag 'capsule-7135734'
	container "$REGISTRY_HOST/capsule/451da157-6f12-4d8e-970f-75a836b046fc:7161f7a5d27480b775308c644088f7d4"

	cpus 1
	memory '8 GB'

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
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7135734.git" capsule-repo
	git -C capsule-repo checkout 734af943e1eb0851c290c81a6d0e5bd8e7dc0dfc --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - han_debug_aind-analysis-arch-upload-db-s3-v2
process capsule_han_debug_aind_analysis_arch_upload_db_s_3_v_2_3 {
	tag 'capsule-6611699'
	container "$REGISTRY_HOST/capsule/25a3c40a-7947-402d-899b-0cc2c8f88f6c:cde317e728dcd01a472d8e3bea6488d6"

	cpus 1
	memory '8 GB'

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
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6611699.git" capsule-repo
	git -C capsule-repo checkout 5034f7f611eaec9748737971b720cb297794bc75 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
