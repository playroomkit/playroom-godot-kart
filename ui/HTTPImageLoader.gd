
## single-use instance for loading an image.
## takes a url and callback in create_http_request.
## returns an image texture to the callback

class_name HTTPImageLoader
extends Node


var callback : Callable

## callback will be called with an image texture
func create_http_request(url: String, callback: Callable):
	
	# save callback
	self.callback = callback
	
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	print("HTTP LOADER: ")
	print(headers)
	print(body)
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)
	
	callback.call(texture)
