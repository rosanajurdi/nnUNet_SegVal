
from nnunet.dataset_conversion.utils import generate_dataset_json
from os.path import join
from batchgenerators.utilities.file_and_folder_operations import *
from numpy import loadtxt
def read_txtfile(txt_path):
    txt_file = open(txt_path, "r").readlines()
    listt = []
    for v in txt_file:
        listt.append(v.split('\n')[0])
    return listt


def generate_custumize_fold(val_path, train_path):
    val_listt = read_txtfile(val_path)
    train_listt = read_txtfile(train_path)
    assert len(val_listt)== 50
    assert len(train_listt) == 100

    splits = [{'train': train_listt, 'val': val_listt}]
    write_pickle(splits, '/Users/rosana.eljurdi/PycharmProjects/nnUNet_SegVal/nnUNet_raw_data_base/nnUNet_raw_data/splits_final_2.pkl')


import os
if __name__ == '__main__':
    root_path = "/Users/rosana.eljurdi/PycharmProjects/nnUNet_SegVal/nnUNet_raw_data_base/nnUNet_raw_data/Task501_SegVal_Hippocampu"
    imagesTr_dir = join(root_path,"imagesTr")
    imagesTs_dir = join(root_path,"imagesTs")
    modalities = ('MRI',)
    """
    :param 
    :param 
    :param : tuple of strings with modality names. must be in the same order as the images (first entry
    corresponds to _0000.nii.gz, etc). Example: ('T1', 'T2', 'FLAIR').
    
"""

    #generate_dataset_json(join(root_path, 'dataset.json'), imagesTr_dir, imagesTs_dir, ('MRI',),
    #                      labels={0: "background", 1: "Anterior", 2: "Posterior"}, dataset_name='Task501_SegVal_Hippocampu', license='Medical Decathlon liscence !')
    val_txt = "/Users/rosana.eljurdi/Documents/Projects/Conf_Seg/Confidence_Intervals_Olivier/Task04_Hippocampus/Splits/train/fold_3/val.txt"
    train_path = "/Users/rosana.eljurdi/Documents/Projects/Conf_Seg/Confidence_Intervals_Olivier/Task04_Hippocampus/Splits/train/fold_3/train.txt"
    generate_custumize_fold(val_txt, train_path)
    print("done")