var start = "localhost:8080/Infact/";

var r1 = ` <div class = "row Mypost-row">
<div class="col-lg-1"> </div>
<div class="col-lg-10 Mypost-main">
<div class="row Mypost-submain" >
<div class = "row"> `;

var r2 = `
      <div class="col-lg-5 "> 
        <div class = " Mypost-image"> `

var r3 = ` </div>
      </div>
      <div class="col-lg-7"> 
        <div class=" Mypost-title">`

var r4 = ` </div>
        <div class=" Mypost-body">`;

var r5 = ` </div> 
			
      `;
var r6 = `</div>
		</div>
      <div class="row User-Option-row">
      	<!-- <button class = "Mybtn Like_Post" type="button" id="Like_Post" > Like </button> -->
      	<!-- <button class = "Mybtn Save_Post" type="button" id="Save_Post" > Save </button> -->
		 <button onclick="viewFunction(this)" class = "Mybtn View_Post" type="button" id="View_Post" value="small"> View </button>
		  </div>
  </div> `

var response = null;
const click_color = "#333333";
const unclick_color = "#57b846";
var upvoted = -1;
var postid = null;
var liked_comments = []
var unliked_comments = []

$(document).ready(function () {

	$.ajax({
		url: 'getUserTopics',
		type: 'get',
		success: function (response) {
			var data = response.data;
			if (response.status == true) {
				if (typeof data == 'undefined' || data.length == 0) {
					// alert("No User Topics")
					// TODO: Add Model ( pop-up to select topics )
					selected_topics = [];
					$('#tags .close').css('display', 'none');
					$("#tags").modal('show');
					gettags();

				} else {
					var usertopic = data;
					for (var i = 0; i < data.length; i++) {
						usertopic[i] = data[i].topic_name;
					}
					console.log(" New " + JSON.stringify(usertopic));
					Cookies.set('user_topics', JSON.stringify(usertopic));
					LoadPosts(2);
				}
			}
		}
	});
	
	

	$('#topic-save').click(function () {
		if (selected_topics == null || selected_topics.length < 3) {
			//			$("#error").html('Please select atleast 3 topics');
			alert('Please select atleast 3 topics');
		} else {
			$.post(
				'setUserTopics',
				{
					values: selected_topics + '',
					sop: $("#sop").val()
				},
				function (data, status, request) {
					if (status == 'success') {
						if (request.getResponseHeader('require_auth') == 'yes') {
							window.location.replace('index.html')
						} else {
							window.location.replace('home.html')
						}
					} else {
						alert('Failed to Add!! Please try again')
					}
				}
			);
		}
	});

	$('#Logout_button').click(function () {
		Logout();
	});
	
	$('#Editor_button').click(function(){
		$('#UserPosts').hide();
		$('#VolunteerPosts').hide();
		$('#User_Editor').show();
	});
	
	
	$('#Volunteer_button').click(function () {
		$('#UserPosts').hide();
		$('#User_Editor').hide();
		LoadVolunteer();
	});
	
	

	$('#Home_button').click(function () {
		$('#UserPosts').show();
		$('#VolunteerPosts').hide();
		$('#User_Editor').hide();
		LoadPosts(5);
	});

	$('#Upvote_button').click(function () {
		if (response == 1) {
			$('#Upvote_button').css('background-color', unclick_color);
			response = null;
		} else {

			if (response == 0) {
				$('#Downvote_button').css('background-color', unclick_color);
			}
			response = 1;
			$('#Upvote_button').css('background-color', click_color);
		}
	});

	$('#Downvote_button').click(function () {
		if (response == 0) {
			$('#Downvote_button').css('background-color', unclick_color);
			response = null;
		} else {

			if (response == 1) {
				$('#Upvote_button').css('background-color', unclick_color);
			}
			response = 0;
			$('#Downvote_button').css('background-color', click_color);
		}
	});

	//	$('.View_Post').click(function(){
	//		console.log("Viewing posts");
	//		$(this).parent().clear();
	//	});


	$('#vol-submit').click(function () {
		var comment = $('#post-comment').val();
		
		if (response == null) {
			alert('Please add Response');
		} else if (comment == null || comment.length == 0) {
			alert('Please add Comment');
		} else {
			
			$.post(
				'AddPostResponse',
				{
					comment: comment,
					response: response,
					post_id: postid,
					liked_comments: liked_comments + '',
					unliked_comments: unliked_comments + ''
				},
				function (data, status) {
					console.log(data)
					if (status == 'success' && JSON.parse(data).status) {
						LoadVolunteer();
					} else {
						//Couldn't sucseed
					}
				}
			);
		}
	});

});

function LoadHome() {

}

function upvote() {

}


function LoadVolunteer() {
	$.post(
		'getVolunteer',
		{},
		function (data, status) {
			if (status != 'success') { }//Do something
			if (data.isVolunteer) {
				if (data.post_available) {
					// TODO: handle jpg and png and confirm security issues
					postid = data.post_id;
					$('.vol-image').attr('src', 'getPostImage?post_id=' + data.post_id);
					$('.post-title').html(data.title);
					$('.post-body').html(data.body);
					$('#comment_list').empty()
					$.each(data.comments, function (index, element) {
						console.log(element.comment + element.response_id)
						$('#comment_list').append(
							'<li class="list-group-item" >' +
							'<div>' + element.comment + '</div>' +
							'<button  onclick="like(\'' + element.response_id + '\',this )"> <i  class="material-icons " style="font-size:36px;" >thumb_up</i> </button>' +
							'<button  onclick="unlike(\'' + element.response_id + '\',this)"> <i class="material-icons " style="font-size:36px;" >thumb_down</i> </button>' +
							'</li>'
						);
						// $('#comment_list').append('<li class="list-group-item">' + element.comment + ' <i></i><span>1</span><i></i>    </li>')
					});
					$('#UserPosts').hide();
					$('#VolunteerPosts').show();
				} else {
					$('#UserPosts').hide();
					$('#VolunteerPosts').show();
					$("#VolunteerPosts").html("No posts are available")
				}
			} else if (data.isApplication) {
				alert("Application Pending")
			} else {
				window.location.replace('volunteer_app.html')
			}
		}
	);
}
function like(comment, but) {
	console.log(but.parentNode);
	if (jQuery.inArray(comment, liked_comments) !== -1) {
		liked_comments.pop(comment);
		but.parentNode.children[1].children[0].style.color = 'black'
	} else if (jQuery.inArray(comment, unliked_comments) !== -1) {
		unliked_comments.pop(comment);
		but.parentNode.children[2].children[0].style.color = 'black'
	} else {
		liked_comments.push(comment);
		but.parentNode.children[1].children[0].style.color = 'green'
	}
}
function unlike(comment, but) {
	if (jQuery.inArray(comment, liked_comments) !== -1) {
		liked_comments.pop(comment);
		but.parentNode.children[1].children[0].style.color = 'black'
	} else if (jQuery.inArray(comment, unliked_comments) !== -1) {
		unliked_comments.pop(comment);
		but.parentNode.children[2].children[0].style.color = 'black'
	} else {
		unliked_comments.push(comment);
		but.parentNode.children[2].children[0].style.color = 'red'
	}
}

function Logout() {
	$.post(
		'Logout',
		{}
		,
		function (response, status) {
			if (status == "success" && response.status == true) {
				window.location.replace("index.html");
			}
		}
	);
}

function viewFunction(but) {
	console.log("F: viewing post");
	//	but.parent.clear();
	console.log(but.attributes.value.nodeValue);
	if (but.attributes.value.nodeValue == "small") {
		console.log("Expanding");
		var ParentNode = but.parentNode.parentNode.children[0];

		var image = ParentNode.children[0].children[0];
		var post_title = ParentNode.children[1].children[0];
		var post_body = ParentNode.children[1].children[1];
		post_body.style.overflow = "hidden";
		//		ParentNode.hidden = true;
		ParentNode.innerHTML = "";
		ParentNode.appendChild(image);
		ParentNode.appendChild(post_title);
		ParentNode.appendChild(post_body);
		ParentNode.style.display = "block";
		but.attributes.value.nodeValue = "large";
		but.innerHTML = "Collapse";


		//		console.log(ParentNode);
		//	
	} else {
		var ParentNode = but.parentNode.parentNode.children[0];
		ParentNode.style.display = "flex";
		var image = ParentNode.children[0];
		var post_title = ParentNode.children[1];
		var post_body = ParentNode.children[2];
		console.log(image.innerHTML);
		ParentNode.innerHTML =
			r2 + image.innerHTML +
			r3 + post_title.innerHTML + r4 + post_body.innerHTML + r5;
		console.log(ParentNode.parentNode);
		$('html, body').animate({ scrollTop: ParentNode.parentNode.parentNode.offsetTop - 100 }, 'slow');

		but.attributes.value.nodeValue = "small";
		but.innerHTML = "View";
	}
	//	if(ParentNode)

	//	console.log(image);
	//	console.log(post_title);
	//	console.log(post_body);

}


function LoadPosts(limit) {
	$("#UserPosts").empty();

	var userTopics = JSON.parse(Cookies.get('user_topics'));

	var postdata = {
		'limit': limit,
		//    	'user_topics': JSON.stringify(userTopics)
	};
	console.log(postdata);
	console.log("Load " + userTopics);
	$.post(
		'getPosts',
		postdata
		,
		function (response, status) {
			if (status == "success" && response.status == true) {
				console.log(response);
				var data = response.data;
				var len = data.length;
				for (var i = 0; i < len; i++) {
					var r = r1 + r2 +
						` <img src= "` + `getPostImage?post_id=` + data[i].post_id + `" id="image" alt=" ` + " Image" + ` "> ` +
						r3 + data[i].title + r4 + data[i].body + r5 + r6;
					$("#UserPosts").append(r);
				}
			}

		}
	);


}