function classif=label2color(label,data_name)
[w, h] = size(label);
im = zeros(w,h,3);

switch lower(data_name)
    case 'paviau'
        map=[192 192 192;
            0 255 0;
            0 255 255;
            0 128 0;
            255 0 255;
            165 82 41;
            128 0 128;
            255 0 0;
            255 255 0];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                end
            end
        end

    case 'center'
        map=[0 0 255;
            0 128 0;
            0 255 0;
            255 0 0;
            142 71 2;
            192 192 192;
            0 255 255;
            246 110 0;
            255 255 0];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                end
            end
        end

    case 'indianp'
        map=[140 67 46;
            0 0 255;
            255 100 0;
            0 255 123;
            164 75 155;
            101 174 255;
            118 254 172;
            60 91 112;
            255,255,0;
            255 255 125;
            255 0 255;
            100 0 255;
            0 172 254;
            0 255 0;
            171 175 80;
            101 193 60];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                    case(10)
                        im(i,j,:)=uint8(map(10,:));
                    case(11)
                        im(i,j,:)=uint8(map(11,:));
                    case(12)
                        im(i,j,:)=uint8(map(12,:));
                    case(13)
                        im(i,j,:)=uint8(map(13,:));
                    case(14)
                        im(i,j,:)=uint8(map(14,:));
                    case(15)
                        im(i,j,:)=uint8(map(15,:));
                    case(16)
                        im(i,j,:)=uint8(map(16,:));
                end
            end
        end

    case 'salinas'
        map=[140 67 46;
            0 0 255;
            255 100 0;
            0 255 123;
            164 75 155;
            101 174 255;
            118 254 172;
            60 91 112;
            255,255,0;
            255 255 125;
            255 0 255;
            100 0 255;
            0 172 254;
            0 255 0;
            171 175 80;
            101 193 60];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                    case(10)
                        im(i,j,:)=uint8(map(10,:));
                    case(11)
                        im(i,j,:)=uint8(map(11,:));
                    case(12)
                        im(i,j,:)=uint8(map(12,:));
                    case(13)
                        im(i,j,:)=uint8(map(13,:));
                    case(14)
                        im(i,j,:)=uint8(map(14,:));
                    case(15)
                        im(i,j,:)=uint8(map(15,:));
                    case(16)
                        im(i,j,:)=uint8(map(16,:));
                end
            end
        end

    case 'dc'
        map=[204 102 102;
            153 51 0;
            204 153 0;
            0 255 0;
            0 102 0;
            0 51 255;
            153 153 153];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                end
            end
        end

    case 'dongtingriver'
        map=[0 0 0;
            44 102 152;
            153 51 0;
            204 153 0;
            0 245 124;
            0 102 0;
            0 51 190;
            153 153 153];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(0)
                        im(i,j,:)=uint8(map(1,:));
                    case(1)
                        im(i,j,:)=uint8(map(2,:));
                    case(2)
                        im(i,j,:)=uint8(map(3,:));
                    case(3)
                        im(i,j,:)=uint8(map(4,:));
                    case(4)
                        im(i,j,:)=uint8(map(5,:));
                    case(5)
                        im(i,j,:)=uint8(map(6,:));
                    case(6)
                        im(i,j,:)=uint8(map(7,:));
                end
            end
        end

        case 'ksc'
        map=[140 67 46;
            0 0 255;
            255 100 0;
            0 255 123;
            164 75 155;
            101 174 255;
            118 254 172;
            60 91 112;
            255,255,0;
            255 255 125;
            255 0 255;
            100 0 255;
            0 172 254];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                    case(10)
                        im(i,j,:)=uint8(map(10,:));
                    case(11)
                        im(i,j,:)=uint8(map(11,:));
                    case(12)
                        im(i,j,:)=uint8(map(12,:));
                    case(13)
                        im(i,j,:)=uint8(map(13,:));
                end
            end
        end

        case 'botswana'
        map=[140 67 46;
            0 0 255;
            255 100 0;
            0 255 123;
            164 75 155;
            101 174 255;
            118 254 172;
            60 91 112;
            255,255,0;
            255 255 125;
            255 0 255;
            100 0 255;
            0 172 254;
            0 255 0];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                    case(10)
                        im(i,j,:)=uint8(map(10,:));
                    case(11)
                        im(i,j,:)=uint8(map(11,:));
                    case(12)
                        im(i,j,:)=uint8(map(12,:));
                    case(13)
                        im(i,j,:)=uint8(map(13,:));
                    case(14)
                        im(i,j,:)=uint8(map(14,:));
                end
            end
        end

        case 'houston'
        map=[140 67 46;
            0 0 255;
            255 100 0;
            0 255 123;
            164 75 155;
            101 174 255;
            118 254 172;
            60 91 112;
            255,255,0;
            255 255 125;
            255 0 255;
            100 0 255;
            0 172 254;
            0 255 0;
            171 175 80];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                    case(10)
                        im(i,j,:)=uint8(map(10,:));
                    case(11)
                        im(i,j,:)=uint8(map(11,:));
                    case(12)
                        im(i,j,:)=uint8(map(12,:));
                    case(13)
                        im(i,j,:)=uint8(map(13,:));
                    case(14)
                        im(i,j,:)=uint8(map(14,:));
                    case(15)
                        im(i,j,:)=uint8(map(15,:));
                end
            end
        end
end

im=uint8(im);
classif=uint8(zeros(w,h,3));
classif(:,:,1)=im(:,:,1);
classif(:,:,2)=im(:,:,2);
classif(:,:,3)=im(:,:,3);
