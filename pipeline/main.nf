#!/usr/bin/env nextflow
// hash:sha256:cabbd9785121ca1d9ba27a5fa502c4778c135309ce3624f4d214df5671424c13

nextflow.enable.dsl = 1

params.foraging_nwb_bonsai_url = 's3://aind-behavior-data/foraging_nwb_bonsai'

foraging_nwb_bonsai_to_han_prod_aind_analysis_arch_job_manager_1 = channel.fromPath(params.foraging_nwb_bonsai_url + "/", type: 'any')
capsule_han_debug_aind_analysis_arch_job_manager_v_2_1_to_capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_2 = channel.create()
capsule_han_debug_aind_analysis_arch_job_wrapper_dynamic_foraging_v_2_2_to_capsule_han_debug_aind_analysis_arch_upload_db_s_3_v_2_3_3 = channel.create()

// capsule - han_prod_aind-analysis-arch-job-manager
process capsule_han_debug_aind_analysis_arch_job_manager_v_2_1 {
	tag 'capsule-7174758'
	container "$REGISTRY_HOST/capsule/ee18ab31-9a75-4a2a-9647-5a89b5ea24d4:1687b4605135d5bf46bf7dc0361de9c7"

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
		git clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7174758.git" capsule-repo
	else
		git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7174758.git" capsule-repo
	fi
	git -C capsule-repo checkout e076cb1295997eea06200d3bcd6ba0ab79af1184 --quiet
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
	tag 'capsule-7135734'
	container "$REGISTRY_HOST/capsule/451da157-6f12-4d8e-970f-75a836b046fc:bdb7cef86a6f7487cec0660d37592622"

	cpus 16
	memory '120 GB'

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
	export CO_CPUS=16
	export CO_MEMORY=128849018880

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7135734.git" capsule-repo
	else
		git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7135734.git" capsule-repo
	fi
	git -C capsule-repo checkout 11a22d42582c6a2515f03e97ac9536998c484112 --quiet
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

	export CO_CAPSULE_ID=d1004134-9823-4e3a-bba7-2b22ac32e42c
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 --branch v2.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9391875.git" capsule-repo
	else
		git clone --branch v2.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9391875.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
