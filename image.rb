require 'rmagick'

def pixel_at(image,x,y)
	image.get_pixels(x,y,1,1).first
end

def whiten_pixel_at(image,x,y)
	the_pix = pixel_at(image,x,y)
	the_pix.red = 65535
	the_pix.green = 65535
	the_pix.blue = 65535
	the_pix.opacity = 0
	image.store_pixels(x,y,1,1,[the_pix])
end

# pixel is considered "black" if it is not totally white
def isBlack?(pixel)	
	return false if pixel.green == 65535 and pixel.blue == 65535 or pixel.red == 65535
	return true
end

def recursive_fill(image,x,y)
	if isBlack?(pixel_at(image,x,y)) then 
		whiten_pixel_at(image,x,y) 
	else
		return
	end
	recursive_fill(image,x-1,y)
	recursive_fill(image,x,y+1)
	recursive_fill(image,x+1,y)
	recursive_fill(image,x,y-1)
end

def find_and_fill_connected_component(image)	
	for i in (0...image.rows)
		for j in (0...image.columns)
			if isBlack?(pixel_at(image,j,i))				
				recursive_fill(image,j,i)
				return 1
			end

		end
	end
	return 0
end


def count_connected_components_for(image_name)
	image = Magick::Image::read(image_name)[0]
	count = 0
	while ( find_and_fill_connected_component(image) != 0 )
		count += 1
	end
	puts "Count is #{count}"
end

count_connected_components_for("cc_1.bmp") # => 1
count_connected_components_for("cc_2.bmp") # => 2
count_connected_components_for("cc_3.bmp") # => 3
count_connected_components_for("cc_4.bmp") # => 4

