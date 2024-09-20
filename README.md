# AIND Analaysis Architecture for Dynamic Foraging

A version 2.0 pipeline for dynamic foraging analysis. (compared to [Han's v1.0 pipeline](https://github.com/AllenNeuralDynamics/aind-foraging-behavior-bonsai-trigger-pipeline))

See [this documentation](https://alleninstitute.sharepoint.com/:w:/s/NeuralDynamics/EU0Nq3tPleRInc2dS6ZLj7IBOIUWv71FZLNAcw_DqHqWlw?e=Mb5k9B).

<img src="https://github.com/user-attachments/assets/e102a925-47ff-40d8-872a-4735fb9d72a3" width=400>

## Components
### [aind-analysis-arch-job-manager](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-manager) (defines and assigns jobs)
1. Generates job jsons like this ([code](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-manager/blob/d87bbb1e38bc01c474ee65e6478c952a0bb84fbd/code/run_capsule.py#L67-L74))
```json
{
  "nwb_name": "697929_2024-02-29_08-49-07.nwb",
  "analysis_spec": {
    "analysis_name": "MLE fitting",
    "analysis_ver": "first version @ 0.10.0",
    "analysis_libs_to_track_ver": [
      "aind_dynamic_foraging_models"
    ],
    "analysis_args": {
      "agent_class": "ForagerLossCounting",
      "agent_kwargs": {
        "win_stay_lose_switch": true,
        "choice_kernel": "none"
      },
      "fit_kwargs": {
        "DE_kwargs": {
          "polish": true,
          "seed": 42
        },
        "k_fold_cross_validation": 10
      }
    }
  },
  "job_hash": "82279ae3d4333ea9ac8507efbdc14833bc003a82a3d60fc9843c7619572657de"
},
```
  where `job_hash` is the unique identifier of $Job = Analysis_{ver}(session)$ (see details [here](https://github.com/AllenNeuralDynamics/aind-dynamic-foraging-models/issues/33#issue-2503995854))

2. Insert jobs to `behavior_analysis/job_manager` on docDB ([code](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-manager/blob/d87bbb1e38bc01c474ee65e6478c952a0bb84fbd/code/run_capsule.py#L130)).
3. Assign `pending` jobs to parallel workers in CO pipeline ([code](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-manager/blob/d87bbb1e38bc01c474ee65e6478c952a0bb84fbd/code/run_capsule.py#L135-L143))
### [aind-analysis-arch-job-wrapper-dynamic-foraging](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-wrapper-dynamic-foraging) (analysis wrappers that do the real job)
1. Trigger assigned computation jobs based on the job jsons ([code](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-wrapper-dynamic-foraging/blob/92837a31a4f1f16d8e20c336b8da356466a0f940/code/run_capsule.py#L155))
2. Upload results to docDB and s3 bucket based on the return dict of each computation job ([code](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-wrapper-dynamic-foraging/blob/92837a31a4f1f16d8e20c336b8da356466a0f940/code/run_capsule.py#L125))
3. Update job `status` in the `job_manager` ([code](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-wrapper-dynamic-foraging/blob/92837a31a4f1f16d8e20c336b8da356466a0f940/code/run_capsule.py#L130-L140)).

   Here are some example `status`: "pending", "running", "success", "skipped", "failed"

## Example result
- In collection `behavior_analysis/mle_fitting`
<img src="https://github.com/user-attachments/assets/c893d6ba-a59d-4b7e-ab59-5d023cbb5906" width=500>

## How to retrieve results from docDB?
1. By REST API (recommended. See [doc here for details](https://aind-data-access-api.readthedocs.io/en/latest/UserGuide.html#document-database-docdb))
2. By URL
    - For example, you can get the example result above by [this URL](https://api.allenneuraldynamics-test.org/v1/behavior_analysis/mle_fitting?filter={%22job_hash%22:%2282279ae3d4333ea9ac8507efbdc14833bc003a82a3d60fc9843c7619572657de%22}):
      ```
      https://api.allenneuraldynamics-test.org/v1/behavior_analysis/mle_fitting?filter={"job_hash":"82279ae3d4333ea9ac8507efbdc14833bc003a82a3d60fc9843c7619572657de"}
      ```
    - Or you can check how many models have been fit for the session "722683_2024-06-27" by [this URL](https://api.allenneuraldynamics-test.org/v1/behavior_analysis/mle_fitting?filter={%22nwb_name%22:{%22$regex%22:%22722683_2024-06-27%22}}&projection={%22job_hash%22:%201,%20%22analysis_results.fit_settings.agent_alias%22:%201,%20%22_id%22:%200})
      ```
      https://api.allenneuraldynamics-test.org/v1/behavior_analysis/mle_fitting?filter={"nwb_name":{"$regex":"722683_2024-06-27"}}&projection={"job_hash": 1, "analysis_results.fit_settings.agent_alias": 1, "_id": 0}
      ```
## How to retrieve results from S3?

Currently all binary outputs of the jobs (such as figures and pkl files) are stored at `s3://aind-scratch-data/aind-dynamic-foraging-analysis/{job_hash}`. For example:

<img src="https://github.com/user-attachments/assets/6b2a2cf8-e74c-47d0-af90-dc0a59203d2e" width=800>

## See also
1. [RL model fitting pipeline](https://github.com/AllenNeuralDynamics/aind-dynamic-foraging-models/issues/33)
2. [Dynamic foraging analysis pipeline V2](https://github.com/AllenNeuralDynamics/aind-foraging-behavior-bonsai-trigger-pipeline/issues/4)

