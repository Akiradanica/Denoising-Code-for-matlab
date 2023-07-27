clc; 
clear;
close all;

% User select an image file
[filename, filepath] = uigetfile({'*.jpg;*.jpeg;*.png;*.gif','Image Files (*.jpg, *.jpeg, *.png, *.gif)'},'%Select an Image File');

% Check if the user canceled the file selection
if isequal(filename, 0) || isequal(filepath, 0)
    disp('Image selection canceled by user.');
    return;
end

% Read the selected image using imread
image_path = fullfile(filepath, filename);

% Load the image
image = imread(filename);

% Get the image width and height in pixels
[height, width, ~] = size(image);  
    % '~' is used to ignore the color channels if the image is RGB

disp(['Image Width: ', num2str(width)]);
disp(['Image Height: ', num2str(height)]);

% Code for Displaying image
imshow(image);
title("Original Image (Dimension: " + num2str(width) + " x " + num2str(height) + ")");
xlabel('X-axis Label');
ylabel('Y-axis Label');
axis on;

%Inputting Cropping values for image
disp('Input Positive Values')
t = input("Top Value: ");
b = input("Bottom Value: ");
l = input("Left Value: ");
r = input("Right Value: ");

% Check if theres an input or the input is zero
if isempty(t) || t == 0 || isempty(b) || b == 0 || isempty(l) || l == 0 || isempty(r) || r == 0
    disp('Input Values invalid, Program has stopped.');
    return;
end

%Applying Salt and Pepper Noise in image
noisy_image = imnoise(image,'salt & pepper',0.05);

% Cropping noisy image
cropped_img = noisy_image(t:b, l:r, :);

% User Input of Sigma and areas to be crop
disp('Input Positive Values')
x = input("Sigma X: ");
y = input("Sigma Y: ");

disp('FOR 2D: Input 0 if you dont want turning the picture Gray')
disp('Otherwise Input positive Values')
z = input("Sigma Z: ");


% Check if the input for z is 0
if z == 0
    z = 0.1;
elseif z <=0
    disp('Invalid Z input')
    return;
end

% Apply denoising
denoised_image = imgaussfilt3(noisy_image, [x, y, z]);

% Denoise Crop image
denoised_crop_image = imgaussfilt3(cropped_img, [x, y, z]);

% Load the source (to be pasted) and destination images
destination_imagey = image;
destination_image = image;

% Perform the paste operation
destination_imagey(t:b, l:r, :) = cropped_img;
destination_image(t:b, l:r, :) = denoised_crop_image;

% Display the original and denoised images
subplot(3, 2, 1), imshow(image), title('Original Image');
subplot(3, 2, 2), imshow(noisy_image), title('Noisy Image');
subplot(3, 2, 3), imshow(denoised_image), title('Denoise Image');
subplot(3, 2, 4), imshow(cropped_img), title('Cropped Noisy Image');
subplot(3, 2, 5), imshow(destination_image), title('Cropped Image on Original');
subplot(3, 2, 6), imshow(destination_imagey), title('Cropped Noisy Image on Original');