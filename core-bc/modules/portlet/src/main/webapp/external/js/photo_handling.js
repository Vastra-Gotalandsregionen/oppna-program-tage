/**
 * Handling of photo uploading
 */
function rotatePhoto(id) {
	$.ajax({
		type: "POST",
		url: window.urlConfig.rotateUrl,
		dataType: "json",
		data: { id: id },
		success: function(result) {
			if (typeof result.success != "undefined" && result.success) {
				$("[id='uploadedphoto']").each(function(index) {
					if ($(this).data("photoid") === id) {
						$(this).context.firstChild.src += "&t=" + new Date().getTime();
					}
				});
			} else {
				alert(result.error);
			}
		},
		error: function(result) {
			alert("Ett fel uppstod på servern när fotot skulle tas bort: " + result.responseText);
		}
	});

	return false; // Prevent default
}

function removePhoto(id) {
	$.ajax({
		type: "POST",
		url: window.urlConfig.removeUrl,
		dataType: "json",
		data: { id: id },
		success: function(result) {
			if (typeof result.success != "undefined" && result.success) {
				$("[id='uploadedphoto']").each(function(index) {
					if ($(this).data("photoid") === id) {
						$(this).remove();
					}
				});
				// remove selected id from the id array, and set the content as value of the 'photos' input element
				window.photoIds = jQuery.grep(window.photoIds, function (a) { return a != id; });
				$("#photos").val(window.photoIds);
			} else {
				alert(result.error);
			}
		},
		error: function(result) {
			alert("Ett fel uppstod på servern när fotot skulle tas bort: " + result.responseText);
		}
	});
}
	
function initFileUploader(loadingImage) {
	// array to store the id's of the selected photos in, is copied to the value of the photos input field
	if ($("#photos").val() !== "") {
		window.photoIds = $("#photos").val().split(",");
		for (n in window.photoIds ) {
			window.photoIds[n] = parseInt(window.photoIds[n]);
			$("#thumbnails").append(
				"<div data-photoid=\"" + window.photoIds[n] + "\" id=\"uploadedphoto\"><img class=\"thumbnail\" src=\"" + window.urlConfig.thumbnailUrl + "&id=" + window.photoIds[n] + "\"><br/><br/><a class=\"btn btn-danger\" href=\"#\" onclick=\"removePhoto(" + window.photoIds[n] + ");\">Ta bort</a><a class=\"btn btn-default\" href=\"#\" onclick=\"return rotatePhoto(" + window.photoIds[n] + ");\">Rotera</a> </div>"
			);
		}
	} else {
		window.photoIds = [];
	}
	new qq.FileUploader({
		element: $("#upload-area").get(0),
		uploadButtonText: "Välj filer",
		cancelButtonText: "Avbryt",
		allowedExtensions: ["png","jpg","jpeg","gif","bmp"],
		action: window.urlConfig.uploadUrl,
		debug: false,
		disableDefaultDropzone: true,
		forceMultipart: true,
		maxConnections: 1,
		stopOnFirstInvalidFile: false,
		sizeLimit: 8388608,
		template: "<div class=\"qq-uploader\">" +
			"<div class=\"qq-upload-button\">{uploadButtonText}</div>" +
			"<div style=\"display:none\" class=\"qq-upload-list\"></div>" +
			"</div>",
		messages: {
			typeError: "{file} har en otillåten filändelse. Tillåtna filändelser: {extensions}.",
			sizeError: "{file} är för stor, maximalt tillåten storlek är {sizeLimit}.",
			minSizeError: "{file} är för liten, minsta tillåtna storlek är {minSizeLimit}.",
			emptyError: "{file} är tom, vänligen välj filer igen utan att ta med denna fil.",
			noFilesError: "Inga filer att ladda upp.",
			onLeave: "Om du lämnar sidan nu så kommer de aktiva uppladdningarna att avbrytas."
		},
		showMessage: function(message){
		},
		onUpload: function(id, fileName) {
			$("#upload-info").html("laddar upp <b>" + fileName + "</b> <img class=\"thumbnail\" src='" + loadingImage + "'>");
		},         
	    onComplete: function(id, fileName, result){
			$("#upload-info").html("");
			if (result.success) {
				window.photoIds.push(result.id);
				$("#photos").val(window.photoIds);
				$("#thumbnails").append(
					"<div data-photoid=\"" + result.id + "\" data-photowidth=\"" + result.width + "\" data-photoheight=\"" + result.height + "\" data-filename=\"" + fileName + "\" id=\"uploadedphoto\"><img class=\"thumbnail\" src=\"" + window.urlConfig.thumbnailUrl + "&id=" + result.id + "\"><br/><br/><a class=\"btn btn-danger\" href=\"#\" onclick=\"removePhoto(" + result.id + ");\">Ta bort</a><a class=\"btn btn-default\" href=\"#\" onclick=\"return rotatePhoto(" + result.id + ");\">Rotera</a></div>"
				);
			}
		},
		onError: function(id, fileName, reason) {
			alert(reason);
		}            
	});
}
