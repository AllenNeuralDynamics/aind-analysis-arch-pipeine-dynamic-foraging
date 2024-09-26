# AIND Analaysis Architecture for Dynamic Foraging

A version 2.0 pipeline for dynamic foraging analysis. (compared to [Han's v1.0 pipeline](https://github.com/AllenNeuralDynamics/aind-foraging-behavior-bonsai-trigger-pipeline))

See [this documentation](https://alleninstitute.sharepoint.com/:w:/s/NeuralDynamics/EU0Nq3tPleRInc2dS6ZLj7IBOIUWv71FZLNAcw_DqHqWlw?e=Mb5k9B).

<img src="https://github.com/user-attachments/assets/e102a925-47ff-40d8-872a-4735fb9d72a3" width=400>

<br>
<img src="https://github.com/user-attachments/assets/60a04e27-9192-452e-9159-212bb2ed4cef" width=1000>

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
  where `job_hash` is the unique identifier of $Job = Analysis_{ver, args}(session)$ (see details [here](https://github.com/AllenNeuralDynamics/aind-dynamic-foraging-models/issues/33#issue-2503995854))

2. Insert jobs to `behavior_analysis/job_manager` on docDB ([code](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-manager/blob/d87bbb1e38bc01c474ee65e6478c952a0bb84fbd/code/run_capsule.py#L130)).
3. Assign `pending` jobs to parallel workers in CO pipeline ([code](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-manager/blob/d87bbb1e38bc01c474ee65e6478c952a0bb84fbd/code/run_capsule.py#L135-L143))
### [aind-analysis-arch-job-wrapper-dynamic-foraging](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-wrapper-dynamic-foraging) (analysis wrappers that do the real job)
1. Trigger assigned computation jobs based on the job jsons ([code](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-wrapper-dynamic-foraging/blob/92837a31a4f1f16d8e20c336b8da356466a0f940/code/run_capsule.py#L155))
2. Upload results to docDB and s3 bucket based on the return dict of each computation job ([code](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-wrapper-dynamic-foraging/blob/92837a31a4f1f16d8e20c336b8da356466a0f940/code/run_capsule.py#L125))
3. Update job `status` in the `job_manager` ([code](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-wrapper-dynamic-foraging/blob/92837a31a4f1f16d8e20c336b8da356466a0f940/code/run_capsule.py#L130-L140)).

## Example jobs
- In collection `behavior_analysis/job_manager`
- `status` of a job could be "pending", "running", "success", "skipped", "failed", etc.
- A pending job
  
    ![image](https://github.com/user-attachments/assets/74c5147f-d6b5-4061-8ec6-bf1c13410d98)
- A success job
  
    ![image](https://github.com/user-attachments/assets/623f0efb-6f5f-4bf3-a82e-63b149c935d6)

     - `docDB_id`: the `_id` of the result record in the `collection_name`
     - `s3_location`: the path to the s3 folder where binary results are stored
     - `log`: the full log of during the analysis

## Example results
- In collection `behavior_analysis/mle_fitting`
<img src="https://github.com/user-attachments/assets/c893d6ba-a59d-4b7e-ab59-5d023cbb5906" width=500>

## How to retrieve results from docDB?
See [doc here for details](https://aind-data-access-api.readthedocs.io/en/latest/UserGuide.html#document-database-docdb)
1. By REST API (recommended)
   
    Let's get all fitted models for session 720956_2024-07-17_13-02-47.
    ```python
    import json
    import requests
    import numpy as np
    
    URL = "https://api.allenneuraldynamics-test.org/v1/behavior_analysis/mle_fitting"
    filter = {
        "nwb_name": "720956_2024-07-17_13-02-47.nwb",  # Session id,
        }
    projection = {
        "analysis_results.fit_settings.agent_alias": 1,
        "_id": 0,
    }
    response = requests.get(URL, params={"filter": json.dumps(filter), "projection": json.dumps(projection)})
    fitted_models = [item["analysis_results"]["fit_settings"]["agent_alias"] for item in response.json()]
    fitted_models
    ```
    output (see [here](https://foraging-behavior-browser.allenneuraldynamics-test.org/RL_model_playground#all-available-foragers) for what `agent_alias` means)
    ```bash
    ['WSLS',
     'QLearning_L1F1_CK1_softmax',
     'QLearning_L2F0_CK1_epsi',
     'QLearning_L2F1_CKfull_softmax',
     'LossCounting']
    ```
    
    and retrieve the results of Bari2019 model for this session
    ```python
    filter = {
        "nwb_name": "720956_2024-07-17_13-02-47.nwb",  # Session id,
        "analysis_results.fit_settings.agent_alias": "QLearning_L1F1_CK1_softmax",  # Bari2019 model
    }
    projection = {
        "analysis_results.params": 1,
        "analysis_results.fitted_latent_variables": 1,
        "_id": 0,
    }
    response = requests.get(URL, params={"filter": json.dumps(filter), "projection": json.dumps(projection)})
    record_dict = response.json()[0]
    
    # Fitted parameters
    params = record_dict["analysis_results"]["params"]
    
    # Fitted latent variables
    fitted_latent = record_dict["analysis_results"]["fitted_latent_variables"]
    
    print(params)
    print(fitted_latent.keys())
    print(np.array(fitted_latent["q_value"]).shape)
    ```
   output
   ```bash
   {'learn_rate': 0.2507656379736507, 'forget_rate_unchosen': 0.2983798859486771, 'choice_kernel_relative_weight': 0.11071091482286803, 'biasL': 1.1123296294263654, 'softmax_inverse_temperature': 4.6676500177210904, 'choice_kernel_step_size': 1}
   dict_keys(['q_value', 'choice_kernel', 'choice_prob'])
   (2, 437)
   ```
3. By `aind-data-access-api` (see [doc here for details](https://aind-data-access-api.readthedocs.io/en/latest/UserGuide.html#document-database-docdb))
4. By URL
    - For example, get the example result above by [this URL](https://api.allenneuraldynamics-test.org/v1/behavior_analysis/mle_fitting?filter={%22job_hash%22:%2282279ae3d4333ea9ac8507efbdc14833bc003a82a3d60fc9843c7619572657de%22}):
      ```
      https://api.allenneuraldynamics-test.org/v1/behavior_analysis/mle_fitting?filter={"job_hash":"82279ae3d4333ea9ac8507efbdc14833bc003a82a3d60fc9843c7619572657de"}
      ```
    - Check how many models have been fit for the session "722683_2024-06-27" by [this URL](https://api.allenneuraldynamics-test.org/v1/behavior_analysis/mle_fitting?filter={%22nwb_name%22:%20%22720956_2024-07-17_13-02-47.nwb%22}&projection={%22job_hash%22:%201,%20%22analysis_results.fit_settings.agent_alias%22:%201,%20%22_id%22:%200})
      ```
      https://api.allenneuraldynamics-test.org/v1/behavior_analysis/mle_fitting?filter={"nwb_name": "720956_2024-07-17_13-02-47.nwb"}&projection={"job_hash": 1, "analysis_results.fit_settings.agent_alias": 1, "_id": 0}
      ```
    - Get fitted parameter and latent variables of a certain fitting (this [URL](https://api.allenneuraldynamics-test.org/v1/behavior_analysis/mle_fitting?filter={%22nwb_name%22:%20%22720956_2024-07-17_13-02-47.nwb%22,%20%22analysis_results.fit_settings.agent_alias%22:%20%22QLearning_L2F1_CKfull_softmax%22}&projection={%22analysis_results.params%22:%201,%20%22analysis_results.fitted_latent_variables%22:%201,%20%22_id%22:%200}))
      ```
      https://api.allenneuraldynamics-test.org/v1/behavior_analysis/mle_fitting?filter={"nwb_name": "720956_2024-07-17_13-02-47.nwb", "analysis_results.fit_settings.agent_alias": "QLearning_L2F1_CKfull_softmax"}&projection={"analysis_results.params": 1, "analysis_results.fitted_latent_variables": 1, "_id": 0}
      ```      
      
## How to retrieve results from S3?

Currently all binary outputs of the jobs (such as figures and pkl files) are stored at `s3://aind-scratch-data/aind-dynamic-foraging-analysis/{job_hash}`. For example:

<img src="https://github.com/user-attachments/assets/6b2a2cf8-e74c-47d0-af90-dc0a59203d2e" width=800>

## Parameters of the pipeline

<img src="https://github.com/user-attachments/assets/0b38a51e-0386-46da-8be7-98843b0d101c" width=600>

## How to add more first-order analyses?
1. Add your analysis wrapper [here](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-wrapper-dynamic-foraging/tree/main/code/analysis_wrappers), in a similar format as `mle_fitting.py`
2. Register your analysis to the `ANALYSIS_MAPPER` [here](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-wrapper-dynamic-foraging/blob/92837a31a4f1f16d8e20c336b8da356466a0f940/code/run_capsule.py#L32).
3. Add your analysis specifications to `analysis_specs` [here](https://github.com/AllenNeuralDynamics/aind-analysis-arch-job-manager/blob/d87bbb1e38bc01c474ee65e6478c952a0bb84fbd/code/run_capsule.py#L36).

## Streamlit dashboard to monitor all job status
Coming...

## See also
1. [RL model fitting pipeline](https://github.com/AllenNeuralDynamics/aind-dynamic-foraging-models/issues/33)
2. [Dynamic foraging analysis pipeline V2](https://github.com/AllenNeuralDynamics/aind-foraging-behavior-bonsai-trigger-pipeline/issues/4)

