function [] = image_show_and_print(dataset_name, map)
figure;
imshow(map);

print_name = ['output\', dataset_name, '_map','.eps'];
print(print_name,'-depsc','-r600');
