var ra0 =`
          <div class = "row Mypost-row" data-value="`;

var ra1	=`">
          <div class="col-lg-1"> </div>
          <div class="col-lg-11 Mypost-main"> 
            <div class="row Mypost-submain" >
            <div class = "row stat-row"> 
            	<img class = "stat-img" alt="responses-icon" src="./images/response.png">
            	<div class = "stat-total">
                        `;
                        
var ra2 =                 `
            	</div>
            	<img class = "stat-img" alt="correct-icon" src="./images/correct.png">
            	<div class = "stat-upvote">
                        `;
            
var ra3 =            `
            	</div>
            	<img class = "stat-img" alt="correct-icon" src="./images/incorrect.png">
            	<div class = "stat-downvote">
                  `;
var ra4 =            `
            	</div>
            </div>
              <div class = "row ">`;
var ra5 =               
              `
                <div class="col-lg-5 "> 
                  <div class = "Mypost-image"> `;
                  
var ra6 =      `
                  </div>
                </div>
                <div class="col-lg-7"> 
                  <div class="Mypost-title"> `;
                  
var ra7 =      `
                  </div>
                  <div class="Mypost-body">`;
                  
var  ra8 =     `
                  </div>  `;

var ra9  =  `
                </div>
              </div>
                  <div class="row User-Option-row" >
                        <button onclick=approve_post(this) class = "Mybtn Accept_btn" type="button"  > Approve </button>
                        <button onclick=reject_post(this) class = "Mybtn Reject_btn" type="button" > Reject </button>  
                  		<button onclick=view_responses_post(this,10) class = "Mybtn View_responses_btn" type="button" > View Responses </button>
                  		<button onclick=view_post(this) class = "Mybtn View_btn" type="button" value="small"> View Post</button>
                  </div>
                </div>
              </div>
          </div>`;



var ap1 = `
<div class = "row Mypost-row" data-value='`


var ap2 = `' >
	<div class="row  Mypost-main" >
	<div class="col-lg-2"> </div>
	<div class="col-lg-8 Mypost-submain">
	<div class = "row ">
        <div class=" Mypost-title">`

var ap3 =`
        </div> 
        
         <div class=" Mypost-body">`


var ap4 =`    </div> 
        	
	</div>`
var ap5 =	`
     <div class="row User-Option-row">
      	 <button onclick=accept_reject_vol(this,1) class = "Mybtn Accept_btn" type="button" id="Accept" > Accept </button>
      	 <button onclick=accept_reject_vol(this,0) class = "Mybtn Reject_btn" type="button" id="Reject" > Reject </button>
		 <button onclick="viewFunction(this)" class = "Mybtn View_Post" type="button" id="View_Post" value="small"> View </button>
	</div>
	 </div>
	 <div class="col-lg-2"> </div>
      </div>
      </div>

`;


$(document).ready(function () { 
      
//	LoadVerificationPosts(3);
	$('#Home_button').click(function () {
		$('#Applications').hide();
		$('#User_Editor').hide();
		$('#VerificationPosts').show();
//		TODO: Hardcoded limit
		LoadVerificationPosts(5);
	});
	
	$('#Applications-btn').click(function(){
		$('#Applications').show();
		$('#User_Editor').hide();
		$('#VerificationPosts').hide();
//		TODO: Hardcoded limit
		LoadApplications(5);
	});
	$('#Editor_button').click(function(){
		$('#Applications').hide();
		$('#VerificationPosts').hide();
		$('#User_Editor').show();
	});
	$('#Volunteers-btn').click(function(){
			
		});
	$('#Logout-btn').click(function(){
			Logout();
	});
//	TODO: Hardcoded limit
	LoadVerificationPosts(5);
	
	
});


function approve_post(but){
	var super_parent = but.parentNode.parentNode.parentNode.parentNode;
	console.log(super_parent);
	var post_id = super_parent.attributes[1].nodeValue;
	console.log(post_id);
	
	
	$.post(
			"AdminAcceptPost",
			{
				post_id:post_id,
			},
			function(data,status){
				console.log(status);
				if(status=='success' && data.status){
					console.log("Accepted "+post_id);
						super_parent.style.display = "none";//TOdo
					}else alert("Error !!");
				}
		);
	
}


function reject_post(but){
	var super_parent = but.parentNode.parentNode.parentNode.parentNode;
	console.log(super_parent);
	var post_id = super_parent.attributes[1].nodeValue;
	console.log(post_id);
	$.post(
			"AdminRejectpost",
			{
				post_id:post_id,
			},
			function(data,status){
				if(status=='success' && data.status){
					console.log("Rejected "+post_id);
					console.log(parent.parentNode.parentNode);
						super_parent.style.display = "none";;//TOdo
					}else {
						alert("Error !!");
					}
				}
		);
	
}

function accept_reject_vol(but,accept){
	var parent =  but.parentNode.parentNode;
	console.log(parent.parentNode.parentNode)
	var userid = parent.parentNode.parentNode.attributes[1].nodeValue;
	
	console.log(parent.parentNode.parentNode);
	
	$.post(
		"AcceptRejectVol",
		{
			user_id:userid,
			accept:accept
		},
		function(data,status){
			if(status=='success' && data.status){	
			parent.parentNode.parentNode.style.display = "none";
				
				
			}else alert("Error !!");
			
		}
	);
}

function view_responses_post(but,limit){
	var super_parent = but.parentNode.parentNode.parentNode.parentNode;
	var post_id = super_parent.attributes[1].nodeValue;
//	responses_comments
	$('#responses_comment_list').empty()
	$("#responses_comments").modal('show');
	$.post(
		"getResponses",
		{
			post_id:post_id,
			limit:limit
		},
		function(data,status){
			if(status=='success' && data.status){	
				
				$.each(data.data, function (index, element) {
					console.log(element);
					console.log(element.response_id);
					
					$('#responses_comment_list').append(
						'<li class="list-group-item" >' +
						'<div>' + element.comment + '</div>' +
//						'<button  onclick="like(\'' + element + '\',this )"> <i  class="material-icons " style="font-size:36px;" >cloud</i> </button>' +
//						'<button  onclick="unlike(\'' + element.response_id + '\',this)"> <i class="material-icons " style="font-size:36px;" >cloud</i> </button>' +
						'</li>'
					);
					// $('#comment_list').append('<li class="list-group-item">' + element.comment + ' <i></i><span>1</span><i></i>    </li>')
				});	
				
			}else alert("Error !!");
			
		}
	);
	
	
	
}

function viewFunction(but){
	console.log(but);
	var parent =  but.parentNode.parentNode;
	if (but.attributes[1].value.nodeValue == "small") {
	parent.children[0].children[1].style.overflow = "visible";
	but.attributes[1].value.nodeValue = "large";
	but.innerHTML = "Collapse";
	}else{
		parent.children[0].children[1].style.overflow = "hidden";
		but.attributes[1].value.nodeValue = "small";
		but.innerHTML = "View";
		$('html, body').animate({ scrollTop: parent.parentNode.parentNode.offsetTop - 100 }, 'slow');
	}
}

function view_post(but){
	
	console.log("F: viewing post");
	//	but.parent.clear();
	console.log(but.attributes.value.nodeValue);
	
	if (but.attributes.value.nodeValue == "small") {
		console.log("Expanding");
		var ParentNode = but.parentNode.parentNode.children[1];
		
		
		var image = ParentNode.children[0].children[0];
		var post_title = ParentNode.children[1].children[0];
		var post_body = ParentNode.children[1].children[1];
		

//		console.log(ParentNode);
//		console.log(image);
//		console.log(post_title);
//		console.log(post_body);
//		
		post_body.style.overflow = "hidden";
		//		ParentNode.hidden = true;
		ParentNode.innerHTML = "";
		ParentNode.appendChild(image);
		ParentNode.appendChild(post_title);
		ParentNode.appendChild(post_body);
		ParentNode.style.display = "block";
		but.attributes.value.nodeValue = "large";
		but.innerHTML = "Collapse";


				
		//	
	} else {
		var ParentNode = but.parentNode.parentNode.children[1];
		ParentNode.style.display = "flex";
		var image = ParentNode.children[0];
		var post_title = ParentNode.children[1];
		var post_body = ParentNode.children[2];
		console.log(image.innerHTML);
		ParentNode.innerHTML =
			ra5 + image.innerHTML +
			ra6 + post_title.innerHTML + ra7 + post_body.innerHTML + ra8;
		console.log(ParentNode.parentNode);
		$('html, body').animate({ scrollTop: ParentNode.parentNode.parentNode.offsetTop - 100 }, 'slow');

		but.attributes.value.nodeValue = "small";
		but.innerHTML = "View";
	}
	
	
	
}
function LoadVolunteers(limit){
	
}
    
function LoadApplications(limit){
	$('#Applications').empty();
	$.post(
			'getApplication',
			{ limit: limit },
			function (response, status) {
				if (status == "success" && response.status == true) {
					console.log(response);
					var data = response.data;
					var len = data.length;
					var user = [];
					var user_topic = new Object();;
					var sop = new Object();;
					for(var i =0;i<len;i++){
						if(user_topic[data[i].user_id] == undefined){
							user.push(data[i].user_id);
							sop[data[i].user_id] = data[i].sop;
							user_topic[data[i].user_id] =  [data[i].topic_name];
						}else{
							user_topic[data[i].user_id].push(data[i].topic_name);
						}
						
						
					}
					
					for(var i =0;i<user.length;i++){
						var uid = user[i];
						var ap = ap1 + uid + ap2 + user_topic[uid] + ap3 + sop[uid] + ap4 + ap5;
						
					}
					
					$("#Applications").append(ap);
					
//					console.log(user);
//					console.log(sop);
					
					
					
				}

			}
		);

}


function Logout() {
	$.post(
		'Logout',
		{}
		,
		function (response, status) {
			if (status == "success" && response.status == true) {
				window.location.replace("admin_login.html");
			}
		}
	);
}

function LoadVerificationPosts(limit){
      $("#VerificationPosts").empty();

	var postdata = {
		'limit': limit,
		//    	'user_topics': JSON.stringify(userTopics)
	};
	console.log(postdata);
	
	$.post(
		'getVerificationPosts',
		{ limit: limit }
		,
		function (response_post, status) {
			if (status == "success" && response_post.status == true) {
				console.log(response_post);
				data = response_post.data;
				var len = data.length;
				var i =0;
				console.log(i);
				for( i= 0;i<len;i++){
				$.post(
						'getResponses',
						{  post_id: data[i].post_id,
							limit: limit}
						,
						function (response_res, status) {
							if (status == "success" && response_res.status == true) {
								console.log(response_res);
								console.log(i);
								i = i-1;
								var correct = 0;
								var incorrect = 0;
								
								var data1 = response_res.data;
								var len1 = data1.length;
								for(var j = 0;j<len1;j++){
									if(data1[j].verify == true){
										correct++;
									}else{
										incorrect++;
									}
								}
								 
									var r = ra0 + data[i].post_id + ra1 + len1 + ra2 + correct + ra3 + incorrect + ra4 +
										ra5 +
										` <img src= "` + `getPostImage?post_id=` + data[i].post_id + `" id="image" alt=" ` + " Image" + ` "> ` +
										ra6 + data[i].title + ra7 + data[i].body + ra8 + ra9;
									$("#VerificationPosts").append(r);
								
								
							}

						}
					);
				}
				}
			});
	

}