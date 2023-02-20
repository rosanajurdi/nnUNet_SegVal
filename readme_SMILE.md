
This is the nnUnet repository used to generate the results for the SMILE UHURA challenge. For steps on installation and usage of nnUnet, please check the initial repository.
In this repositoy, we will only include the changed we did to the nnUnet code. 

# Generating the json files. 

the first step is to put the dataset in a format realizable by the nnunet framework. 
This format is similar to the MSD challenge and is described below:

- the dataset should be placed in [nnUNet_raw_data](/Users/rosana.eljurdi/PycharmProjects/nnUNet_SMILE/nnUNet_raw_data_base/nnUNet_raw_data) with the following format:

```
nnUNet_raw_data_base/nnUNet_raw_data/
    ├── Task001_BrainTumour
    ├── Task600_SMILE
            ├── dataset.json (to be generated)
            ├── splits_final.pkl (to be generated)
            ├── imagesTr
            ├── imagesTs
            └── labelsTr
    ├── ...
```

- make sure that the id number following Task is greater than 500, so that no compatibility 
issues are generated with other pre-trained models.
- we do our own splits which can be checked in [generate_custumize_fold](/Users/rosana.eljurdi/PycharmProjects/nnUNet_SMILE/main.py) and store them in splits_final.pkl. 
- generate the .json files. we update the [generate_dataset_json](/Users/rosana.eljurdi/PycharmProjects/nnUNet_SMILE/nnunet/dataset_conversion/utils.py) as follows:


- To  generate the .json file, the [./generate_dataset_json.py](main.py) is run, with the following updated id extraction function:
```
def get_identifiers_from_splitted_files(folder: str):
    # changed to accomodate cutumized splits of msd data
    #uniques = np.unique([i[:-12] for i in subfiles(folder, suffix='.nii.gz', join=False)])
    uniques = [i[12:].split('.nii.gz')[0] for i in subfiles(folder, suffix='.nii.gz', join=False)]
    return uniques
```
The script takes as input the 
```
root_path = "/Users/rosana.eljurdi/PycharmProjects/nnUNet_SegVal/nnUNet_raw_data_base/nnUNet_raw_data/Task600_SMILE"
imagesTr_dir = join(root_path,"imagesTr")
imagesTs_dir = join(root_path,"imagesTs")
modalities = ('MRI',)
labels = {0: "background", 1: "Vessels"}
    

generate_dataset_json(join(root_path, 'dataset.json'), imagesTr_dir, None, modalities,
                      labels=labels, dataset_name='Task600_SMILE', license='SMILE UHURA Challange, licence from synapse !')
```

An example of the corresponding .json file is as follows. Realize the only difference is the 
number of training and testing examples. The running code for this can be found in [](main.py) which could be 
discarded if you are using the terminal for convesions.
```
{
    {
    "description": "",
    "labels": {
        "0": "background",
        "1": "Vessels"
    },
    "licence": "SMILE UHURA Challange, licence from synapse !",
    "modality": {
        "0": "MRI"
    },
    "name": "Task600_SMILE",
    "numTest": 0,
    "numTraining": 12,
    "reference": "",
    "release": "0.0",
    "tensorImageSize": "4D",
    "test": [],
    "training": [
        {
            "image": "./imagesTr/sub004.nii.gz",
            "label": "./labelsTr/sub004.nii.gz"
        },
        {
            "image": "./imagesTr/sub005.nii.gz",
            "label": "./labelsTr/sub005.nii.gz"
        },
        {
            "image": "./imagesTr/sub006.nii.gz",
            "label": "./labelsTr/sub006.nii.gz"
        },
        {
            "image": "./imagesTr/sub008.nii.gz",
            "label": "./labelsTr/sub008.nii.gz"
        },
        {
            "image": "./imagesTr/sub009.nii.gz",
            "label": "./labelsTr/sub009.nii.gz"
        },
        {
            "image": "./imagesTr/sub011.nii.gz",
            "label": "./labelsTr/sub011.nii.gz"
        },
        {
            "image": "./imagesTr/sub012.nii.gz",
            "label": "./labelsTr/sub012.nii.gz"
        },
        {
            "image": "./imagesTr/sub014.nii.gz",
            "label": "./labelsTr/sub014.nii.gz"
        },
        {
            "image": "./imagesTr/sub015.nii.gz",
            "label": "./labelsTr/sub015.nii.gz"
        },
        {
            "image": "./imagesTr/sub018.nii.gz",
            "label": "./labelsTr/sub018.nii.gz"
        },
        {
            "image": "./imagesTr/sub019.nii.gz",
            "label": "./labelsTr/sub019.nii.gz"
        },
        {
            "image": "./imagesTr/sub020.nii.gz",
            "label": "./labelsTr/sub020.nii.gz"
        }
    ]
}
```

# Generating the custumized splits_final.pkl

Our code runs on custumized folds (train=10 samples, val=2 samples)
and a separate test set of 2 patients. To generate the customized splits_final.pkl, 
we can run the script [generate_custumize_fold](./main.py).
For SMILE, I have done te generated the file by simply specifying the patients manually (patients 
data is small so was fairly easy). You can find this is the main.py or just copy paste the following to 
the a .py script: 

```
    splits = [{'train': ['sub008', 'sub019', 'sub018', 'sub009', 'sub014', 'sub004', 'sub012', 'sub005'],
               'val': ['sub015', 'sub020', 'sub006']}]
    write_pickle(splits, os.path.join('/Users/rosana.eljurdi/PycharmProjects/SMILE-UHURA', 'splits_final.pkl'))
```

# Conversion 
To convert the data into nnUNet compatible the same 
steps found in []() are followed with the path to the new fold dataset. 

```
nnUNet_convert_decathlon_task -i nnUNet_raw_data_base/nnUNet_raw_data/name_of_task
```

In one of the pre-processing steps that patient data needs to be dis-entangled 
into its different modalities under the format: hippocampus_127_0000.nii.gz which are created in 
Task004_SegVal_Hippocampu folder (Task04_SegVal_Hippocampu -> Task004_SegVal_Hippocampu). This doesnt work 
for SMILE, so we need to manually convert the files in Task600_SMILE from 
(**sub006.nii.gz -> sub006_0000.nii.gz**. Note Keep them in the same folder.


The same steps as the one in the example are then conducted 

```
nnUNet_plan_and_preprocess -t id
nnUNet_train 3d_fullres nnUNetTrainerV2 id fold_nb
```

The framework is going to check your split_final.pkl file for pre-decided splits. an example of the beginign fo the program is:
This is custumized to your own split file, so please make sure that your data splits is as you want it. 
```
2022-11-18 14:41:02.312405: The split file contains 5 splits.
2022-11-18 14:41:02.312519: Desired fold for training: 0
2022-11-18 14:41:02.312605: This split has 120 training and 30 validation cases.
```



# Debugging
Running via commands is good but in case you want to debug your code, via an IDE you need to
do two main things. 1) First translate yçu .bashrc file in the original code through editing 
the [](path.py)

```
os.environ.setdefault(key='nnUNet_raw_data_base', value='/Users/rosana.eljurdi/PycharmProjects/nnUNet_SegVal/nnUNet_raw_data_base'
                      )
os.environ.setdefault(key='nnUNet_preprocessed', value='/Users/rosana.eljurdi/PycharmProjects/nnUNet_SegVal/nnUNet_preprocessed'
                      )
os.environ.setdefault(key='RESULTS_FOLDER', value='/Users/rosana.eljurdi/PycharmProjects/nnUNet_SegVal/nnUNet_trained_models'
                      )
```

2) Feed the parameters (3d_fullres nnUNetTrainerV2 4 0) into the parameter entries at the 
debugging configuration. 

Running the inference 
Running the inference is done via the following command. 
```
nnUNet_predict -i INPUT_FOLDER -o OUTPUT_FOLDER -t TASK_NAME_OR_ID -m CONFIGURATION
```
1) you must first activate your environment module load anaconda ... conda activate nnUnet_2
2) you must specify the INPUT_FOLDER which is found in /nnUNet_raw_data_base/nnUNet_raw_data/Task00X_SegVal_datasetname
3) 


# Example Main - 1
```
root_path = "/Users/rosana.eljurdi/PycharmProjects/nnUNet_SegVal/nnUNet_raw_data_base/nnUNet_raw_data/Task01_SegVal_BrainTumor"
    imagesTr_dir = join(root_path,"imagesTr")
    imagesTs_dir = join(root_path,"imagesTs")
    modalities = ("FLAIR","T1w","t1gd","T2w")
    labels = {0: "background", 1: "edema", 2: "non-enhancing tumor", 3:"enhancing tumour"}
    """
    :param 
    :param 
    :param : tuple of strings with modality names. must be in the same order as the images (first entry
    corresponds to _0000.nii.gz, etc). Example: ('T1', 'T2', 'FLAIR').
    
    """

    generate_dataset_json(join(root_path, 'dataset.json'), imagesTr_dir, imagesTs_dir, modalities,
                          labels=labels, dataset_name='Task01_SegVal_BrainTumor', license='Medical Decathlon liscence !')
    val_txt = "/Users/rosana.eljurdi/PycharmProjects/nnUNet_SegVal/nnUNet_raw_data_base/nnUNet_raw_data/Task01_SegVal_BrainTumor/val.txt"
    train_path = "/Users/rosana.eljurdi/PycharmProjects/nnUNet_SegVal/nnUNet_raw_data_base/nnUNet_raw_data/Task01_SegVal_BrainTumor/train.txt"
    generate_custumize_fold(val_txt, train_path)
    print("done")

```