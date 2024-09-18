#!/usr/bin/env nextflow
// hash:sha256:94c3b1fe967c12d57a2bed6783154279283a33a79d15d3d3d7000da3ab842fce

nextflow.enable.dsl = 1

capsule_han_debug_aind_analysis_arch_job_manager_1_to_capsule_han_debug_aind_analysis_arch_dynamic_foraging_2_1 = channel.create()

// capsule - han_debug_aind-analysis-arch-job-manager
process capsule_han_debug_aind_analysis_arch_job_manager_1 {
	tag 'capsule-0951403'
	container "$REGISTRY_HOST/capsule/3d8bc0cf-15dc-49bd-bc5e-91d2d59c0a27"

	cpus 1
	memory '8 GB'

	output:
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
	git -C capsule-repo checkout eb14233baa2ceee0081e278206a5faf425ac6f6c --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - han_debug_aind-analysis-arch-dynamic-foraging
process capsule_han_debug_aind_analysis_arch_dynamic_foraging_2 {
	tag 'capsule-3394271'
	container "$REGISTRY_HOST/capsule/42889a43-860e-43a7-9f72-aea79ae2f4bf"

	cpus 32
	memory '16 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_han_debug_aind_analysis_arch_job_manager_1_to_capsule_han_debug_aind_analysis_arch_dynamic_foraging_2_1

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=42889a43-860e-43a7-9f72-aea79ae2f4bf
	export CO_CPUS=32
	export CO_MEMORY=17179869184

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3394271.git" capsule-repo
	git -C capsule-repo checkout 23305d88c7ad7429f22932e4f07a0840d831c923 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run --parallel_on_jobs 1

	echo "[${task.tag}] completed!"
	"""
}
