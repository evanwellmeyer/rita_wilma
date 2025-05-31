function [mask] = mk_mask(x,y,lat,mask_rad)

    mask = zeros(size(lat,1),size(lat,2));
        
    if x+mask_rad <= size(lat,1) && x-mask_rad >= 1 && y+mask_rad <= size(lat,2) && y-mask_rad >= 1
        mask( x-mask_rad:x+mask_rad , y-mask_rad:y+mask_rad ) = 1;
    elseif x+mask_rad >= size(lat,1) && y+mask_rad >= size(lat,2)
        mask( x-mask_rad:size(lat,1) , y-mask_rad:size(lat,2) ) = 1;
    elseif x+mask_rad >= size(lat,1)
        mask( x-mask_rad:size(lat,1) , y-mask_rad:y+mask_rad ) = 1;
    elseif x-mask_rad <= 1
        mask( 1:x+mask_rad , y-mask_rad:y+mask_rad ) = 1;
    elseif y+mask_rad >= size(lat,2)
        mask( x-mask_rad:x+mask_rad , y-mask_rad:size(lat,2) ) = 1;
    elseif y-mask_rad <= 1
        mask( x-mask_rad:x+mask_rad , 1:y+mask_rad ) = 1;
    end
    
end