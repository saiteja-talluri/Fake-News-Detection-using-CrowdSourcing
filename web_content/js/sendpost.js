var start = "localhost:8080/Infact/";

$(document).ready(function () {

	$('#postForm').submit(function (e) {
		e.preventDefault();
		var post_title = $("#post-title").val();
		var post_body = $("#post-body").val();
		var file_upload = $("#file-upload")[0].files[0];

		console.log(post_title.length);
		console.log(post_body.length);

		if (post_title.length == 0 || post_body.length == 0) {
			alert('Please complete the post');
		} else {

			$('#post-tags .close').css('display', 'none');
			$("#post-tags").modal('show');
			gettags();
		}


	});


	$('#post-topic-save').click(function () {
		if (selected_topics == null || selected_topics.length < 1) {
			//			$("#error").html('Please select atleast 3 topics');
			alert('Please select atleast 1 topic');
		} else {
			var post_title = $("#post-title").val();
			var post_body = $("#post-body").val();
			var file_upload = $("#file-upload")[0].files[0];


			console.log("Submitting the Post")


			var formData = new FormData();
			formData.append("post-title", post_title);
			formData.append("post-body", post_body);
			formData.append("file-upload", file_upload);
			formData.append("values", selected_topics + '');

			$.ajax({
				url: 'addPost',
				type: 'post',
				data: formData,
				//	        enctype:"multipart/form-data",
				contentType: false,
				processData: false,
				success: function (data) {
					//	        	console.log(data);
					window.location.replace('home.html')
					//	        	window.location = window.location.protocol + '//' + (start+"posts.html");
					alert("Added Post");
				}
			});

		}
	});

	//    $("#SendPost").click(function () { 
	//        console.log("Sending");
	//        var title = $("#post-title").val(); 
	//        var articlebody = $("#post-body").val(); 
	//
	//        var imgfile =$("#file-upload")[0].files[0];
	//        console.log("Image File " + imgfile);
	//        var formData = new FormData();
	//        formData.append("title",title);
	//        formData.append("articlebody",articlebody);
	//        formData.append("imagefile",imgfile);
	//        formData.append("file-upload",$("#file-upload"));
	//        formData.append("author_name","Test-Author");
	//            
	//
	//        var url = "addPost";
	//        $.ajax({
	//            url: url,
	//            type:"POST",
	//            data:formData,
	//            enctype:"multipart/form-data",
	//            // contentType:'application/json;charset=UTF-8',
	//            processData: false,
	//            dataType:"json",
	//            success: function(data){
	//                console.log(data);
	//            }
	//          })
	//       
	//    });

});
