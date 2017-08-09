## 3Team Backend playground
Backend project using Ruby on Rails.


사용가능한 API

### 1. Recommended Recipe
```
method: GET
utl: current_url/recipes 
reponse: [{"id":3,"title":"치킨룰라드","url":"http://haemukja.com/recipes/271","image":"http://cloudfront.haemukja.com/vh.php?url=http://d1hk7gw6lgygff.cloudfront.net/uploads/direction/image_file/2959/pad_thumb_1417170189301.jpeg\u0026convert=jpgmin\u0026rt=600"},{"id":4,"title":"콘치즈 샐러드","url":"http://haemukja.com/recipes/275","image":"http://cloudfront.haemukja.com/vh.php?url=http://d1hk7gw6lgygff.cloudfront.net/uploads/direction/image_file/2980/pad_thumb_2014-08-13-10-03-42_deco.jpg\u0026convert=jpgmin\u0026rt=600"},{"id":5,"title":"핫도그","url":"http://haemukja.com/recipes/280","image":"http://cloudfront.haemukja.com/vh.php?url=http://d1hk7gw6lgygff.cloudfront.net/uploads/direction/image_file/3063/pad_thumb_20150213_150413.jpg\u0026convert=jpgmin\u0026rt=600"},{"id":6,"title":"매운족발볶음","url":"http://haemukja.com/recipes/230","image":"http://cloudfront.haemukja.com/vh.php?url=http://d1hk7gw6lgygff.cloudfront.net/uploads/direction/image_file/2476/pad_thumb_IMG_6043.JPG\u0026convert=jpgmin\u0026rt=600"},{"id":7,"title":"빠에야 ","url":"http://haemukja.com/recipes/220","image":"http://cloudfront.haemukja.com/vh.php?url=http://d1hk7gw6lgygff.cloudfront.net/uploads/direction/image_file/2345/pad_thumb_IMG_1546.jpg\u0026convert=jpgmin\u0026rt=600"},{"id":8,"title":"게살크림치즈만두","url":"http://haemukja.com/recipes/223","image":"http://cloudfront.haemukja.com/vh.php?url=http://d1hk7gw6lgygff.cloudfront.net/uploads/direction/image_file/2388/pad_thumb_11.JPG\u0026convert=jpgmin\u0026rt=600"}]
```

### 2. Get Recipe with 해먹남녀 URL 
```
method: POST
utl: current_url/recipes
payload: url: 해먹남녀 주소
response: {"id":3,"title":"치킨룰라드","url":"http://haemukja.com/recipes/271","image":"http://cloudfront.haemukja.com/vh.php?url=http://d1hk7gw6lgygff.cloudfront.net/uploads/direction/image_file/2959/pad_thumb_1417170189301.jpeg\u0026convert=jpgmin\u0026rt=600"}
```





