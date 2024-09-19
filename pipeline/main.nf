#!/usr/bin/env nextflow
// hash:sha256:a2da93ed21cab6b201b04b17093bf4d147d72c402bc258a512c75b5884e1b229

nextflow.enable.dsl = 1

capsule_han_debug_aind_analysis_arch_job_manager_1_to_capsule_han_debug_aind_analysis_arch_dynamic_foraging_2_1 = channel.create()

// capsule - han_debug_aind-analysis-arch-job-manager
process capsule_han_debug_aind_analysis_arch_job_manager_1 {
	tag 'capsule-0951403'
	container "$REGISTRY_HOST/capsule/3d8bc0cf-15dc-49bd-bc5e-91d2d59c0a27:89106f7107e98e91487940ff623a07a5"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH/assigned_jobs", saveAs: { filename -> new File(filename).getName() }

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_han_debug_aind_analysis_arch_job_manager_1_to_capsule_han_debug_aind_analysis_arch_dynamic_foraging_2_1

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
	git -C capsule-repo checkout 2fc268278a5a2047c9bb6a77d98b4c595b658dce --quiet
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

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/jobs' from capsule_han_debug_aind_analysis_arch_job_manager_1_to_capsule_han_debug_aind_analysis_arch_dynamic_foraging_2_1.flatten()

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
	git -C capsule-repo checkout d61bbe42a99ba623f01b9f1b81a9c38c66a7e9ec --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
