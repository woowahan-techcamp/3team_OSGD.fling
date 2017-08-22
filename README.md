# 3Team Backend

framework : Ruby on Rails

server: AWS linux & Nginx

database: sqlite (rails default)



## 사용가능한 API

#### 1. 메인화면 추천메뉴

| method | api      | reponse data                         |
| ------ | -------- | ------------------------------------ |
| GET    | /recipes | [id, subtitle, title, writer, image] |

#### 2. URL >> Recipe

| method | api url  | request data   | response data                            |
| ------ | -------- | -------------- | ---------------------------------------- |
| POST   | /recipes | url = "해먹남녀주소" | id, subtitle, title, writer, image, missed_material, recipe_material, serving |

검색되지 않으면 Status = 'no-content'

#### 3. Recipe >> Products

| method | api url                      | response data                            |
| ------ | ---------------------------- | ---------------------------------------- |
| GET    | /get_products/:id [레시피의 아이디] | [id, name, price, weight, bundle, image] |

#### 4. 메인화면 계절 메뉴

| method | api url | response data                        |
| ------ | ------- | ------------------------------------ |
| GET    | /season | [id, subtitle, title, writer, image] |

####5. 상품 키워드 검색

| method | api url         | request        | response data |
| ------ | --------------- | -------------- | ------------- |
| POST   | /search_product | keyword = "우유" | [id, name]    |

#### 6. 상품 상세정보

| method | api url                | response data                          |
| ------ | ---------------------- | -------------------------------------- |
| GET    | /products/:id[상품의 아이디] | bundle, id, image, name, price, weight |

#### 7. 레시피 상세정보 

| method | api url      | response data                            |
| ------ | ------------ | ---------------------------------------- |
| GET    | /recipes/:id | id, subtitle, title, writer, image, missed_material, recipe_material, serving |

#### 8. 레시피 키워드 검색

| method | api url        | requset      | response   |
| ------ | -------------- | ------------ | ---------- |
| POST   | /search_recipe | keyword="냉콩" | [id, name] |

#### 9. 재료이름 by 재료 ID Array

| method | apiurl         | request             | response   |
| ------ | -------------- | ------------------- | ---------- |
| POST   | /get_materials | materials=[1,2,3,4] | [id, name] |

#### 10 . 상품 상세정보 (input [id])

| method | apiurl        | request            | response                                 |
| ------ | ------------- | ------------------ | ---------------------------------------- |
| POST   | /get_products | products=[1,2,3,4] | [bundle, id, image, name, price, weight] |

#### 11. 재료 키워드 검색

| method | api url          | requset     | response   |
| ------ | ---------------- | ----------- | ---------- |
| POST   | /search_material | keyword="콩" | [id, name] |



## 모델

#### 1. Recipe [레시피]

id,  subtitle, title, writer, image, missed_material, recipe_material, serving

#### 2. Product [상품]

id, name, price, weight, bundle, image, material_id(forein key of material)

#### 3. Material [재료]

id, name

#### 4. RecipeMaterial [레시피 재료 m:n]

id, recipe_id, material_id

#### 5. Unit [단위]

id, name

#### 6. MaterialUnit [재료 유닛 m:n]

id, unit_id, material_id



## DB SEED file

**Season Recipe[9개]** https://github.com/woowahan-techcamp/3team_OSGD.fling/blob/backend/db/seeds/seasons.rb

**Material[744개]** https://github.com/woowahan-techcamp/3team_OSGD.fling/blob/backend/db/seeds/materials.rb 

**Product[718개]** https://github.com/woowahan-techcamp/3team_OSGD.fling/blob/backend/db/seeds/product.rb