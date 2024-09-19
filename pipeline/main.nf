#!/usr/bin/env nextflow
// hash:sha256:1426f16e78aeab81454a429e61df73d22b357881a48c36a8e1baae2be83f7a43

nextflow.enable.dsl = 1

params.foraging_nwb_bonsai_url = 's3://aind-behavior-data/foraging_nwb_bonsai'

foraging_nwb_bonsai_to_han_debug_aind_analysis_arch_job_manager_1 = channel.fromPath(params.foraging_nwb_bonsai_url + "/", type: 'any')
capsule_han_debug_aind_analysis_arch_job_manager_1_to_capsule_han_debug_aind_analysis_arch_dynamic_foraging_2_2 = channel.create()

// capsule - han_debug_aind-analysis-arch-job-manager
process capsule_han_debug_aind_analysis_arch_job_manager_1 {
	tag 'capsule-0951403'
	container "$REGISTRY_HOST/capsule/3d8bc0cf-15dc-49bd-bc5e-91d2d59c0a27:89106f7107e98e91487940ff623a07a5"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH/assigned_jobs", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/foraging_nwb_bonsai' from foraging_nwb_bonsai_to_han_debug_aind_analysis_arch_job_manager_1.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_han_debug_aind_analysis_arch_job_manager_1_to_capsule_han_debug_aind_analysis_arch_dynamic_foraging_2_2

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=3d8bc0cf-15dc-49bd-bc5e-91d2d59c0a27
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0951403.git" capsule-repo
	git -C capsule-repo checkout e6a57c88b520b13ae39a8a023f50919c59fffd99 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_han_debug_aind_analysis_arch_job_manager_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - han_debug_aind-analysis-arch-dynamic-foraging
process capsule_han_debug_aind_analysis_arch_dynamic_foraging_2 {
	tag 'capsule-3394271'
	container "$REGISTRY_HOST/capsule/42889a43-860e-43a7-9f72-aea79ae2f4bf:7161f7a5d27480b775308c644088f7d4"

	cpus 8
	memory '16 GB'

	publishDir "$RESULTS_PATH/$index", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/jobs' from capsule_han_debug_aind_analysis_arch_job_manager_1_to_capsule_han_debug_aind_analysis_arch_dynamic_foraging_2_2.flatten()
	val index from 1..100000

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=42889a43-860e-43a7-9f72-aea79ae2f4bf
	export CO_CPUS=8
	export CO_MEMORY=17179869184

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3394271.git" capsule-repo
	git -C capsule-repo checkout cbccfa5164c081d8ed280c228189329c395a11f7 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_han_debug_aind_analysis_arch_dynamic_foraging_2_args}

	echo "[${task.tag}] completed!"
	"""
}
