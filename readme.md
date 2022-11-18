
This is the nnUnet repository used to generate the results in [](paper) as part of the 
segVal project. For steps on installation and usage of nnUnet, please check the initial repository.
In this repositoy, we will only include the changed we did to the nnUnet code. 

# Generating the json files. 

Despite the fact that we are dealing with MSD data that have json files, nevertheless, our 
paper has different splitd as we dont use the imagesTs of the MSD challenge due to unavailability 
of labels. Rather, we do our own splits which can be checked in [](). For this reason, we had 
to regenerate the .json files. we update the [](utils.py) as follows:

The custumized dataset need to be placed in the following directory as the initial documentation 
recommends: 

```
nnUNet_raw_data_base/nnUNet_raw_data/
    ├── Task001_BrainTumour
    ├── Task004_Hippocampus
            ├── dataset.json (to be generated)
            ├── imagesTr
            ├── imagesTs
            └── labelsTr
    ├── ...
```

To  generate the .json file, the []() is run, with the following updated id extraction function:
```
def get_identifiers_from_splitted_files(folder: str):
    # changed to accomodate cutumized splits of msd data
    #uniques = np.unique([i[:-12] for i in subfiles(folder, suffix='.nii.gz', join=False)])
    uniques = [i[12:].split('.nii.gz')[0] for i in subfiles(folder, suffix='.nii.gz', join=False)]
    return uniques
```

An example of the corresponding .json file is as follows. Realize the only difference is the 
number of training and testing examples. The running code for this can be found in [](main.py) which could be 
discarded if you are using the terminal for convesions.
```
{
    "description": "",
    "labels": {
        "0": "background",
        "1": "Anterior",
        "2": "Posterior"
    },
    "licence": "Medical Decathlon liscence !",
    "modality": {
        "0": "MRI"
    },
    "name": "Task04_SegVal_Hippocampu",
    "numTest": 110,
    "numTraining": 150,
    "reference": "",
    "release": "0.0",
    "tensorImageSize": "4D",
    "test": [
        "./imagesTs/001.nii.gz",
        "./imagesTs/011.nii.gz",
        ...
    ],
    "training": [
        {
            "image": "./imagesTr/003.nii.gz",
            "label": "./labelsTr/003.nii.gz"
        },
        {
            "image": "./imagesTr/004.nii.gz",
            "label": "./labelsTr/004.nii.gz"
        },
        ...
    ]
}
```

Note that the id for the hippocampus (04) was kept so that the same data conversion would be done as the initial 
folds, where only the difference would be the dataset splits. To convert the data into nnUNet compatible the same 
steps found in []() are followed with the path to the new fold dataset.

```
nnUNet_convert_decathlon_task -i nnUNet_raw_data_base/nnUNet_raw_data/Task04_SegVal_Hippocampu/
```

The result is a new dataset in the /nnUNet/nnUNet_raw_data_base/nnUNet_raw_data directory under the name 
Task004_SegVal_Hippocampu 

The same steps as the one in the example are then conducted 

```
nnUNet_plan_and_preprocess -t 4
nnUNet_train 3d_fullres nnUNetTrainerV2 4 0
```

The problem right now is that the validation fold is 120 training and 30 validation. this needs 
to be resolved.

```
2022-11-18 14:41:02.312405: The split file contains 5 splits.
2022-11-18 14:41:02.312519: Desired fold for training: 0
2022-11-18 14:41:02.312605: This split has 120 training and 30 validation cases.
```

