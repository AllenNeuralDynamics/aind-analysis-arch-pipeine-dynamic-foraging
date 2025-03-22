#!/usr/bin/env nextflow
// hash:sha256:babb5ecb00c65cf83c14eadb2b35e82cae12814119457355859cc71f2c96885a

nextflow.enable.dsl = 1

params.foraging_nwb_bonsai_url = 's3://aind-behavior-data/foraging_nwb_bonsai'

foraging_nwb_bonsai_to_han_prod_aind_analysis_arch_job_manager_1 = channel.fromPath(params.foraging_nwb_bonsai_url + "/", type: 'any')
capsule_han_debug_aind_analysis_arch_job_manager_v_2_1_to_capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_2 = channel.create()
capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_to_capsule_han_debug_aind_analysis_arch_upload_db_s_3_v_2_3_3 = channel.create()

// capsule - han_prod_aind-analysis-arch-job-manager
process capsule_han_debug_aind_analysis_arch_job_manager_v_2_1 {
	tag 'capsule-1554778'
	container "$REGISTRY_HOST/published/da058235-42bc-42f9-81e9-ed4e965f660d:v4"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/foraging_nwb_bonsai' from foraging_nwb_bonsai_to_han_prod_aind_analysis_arch_job_manager_1.collect()

	output:
	path 'capsule/results/*' into capsule_han_debug_aind_analysis_arch_job_manager_v_2_1_to_capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_2

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=da058235-42bc-42f9-81e9-ed4e965f660d
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v4.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1554778.git" capsule-repo
	mv capsule-repo/code capsule/code
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
	tag 'capsule-7098858'
	container "$REGISTRY_HOST/published/8385aa1a-d8da-4870-b952-e33733990f23:v4"

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

	export CO_CAPSULE_ID=8385aa1a-d8da-4870-b952-e33733990f23
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v4.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7098858.git" capsule-repo
	mv capsule-repo/code capsule/code
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
	tag 'capsule-9391875'
	container "$REGISTRY_HOST/published/d1004134-9823-4e3a-bba7-2b22ac32e42c:v2"

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

	export CO_CAPSULE_ID=d1004134-9823-4e3a-bba7-2b22ac32e42c
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v2.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9391875.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
