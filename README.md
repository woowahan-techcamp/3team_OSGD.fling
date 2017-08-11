# 3Team Backend

Backend project using Ruby on Rails.

## 사용가능한 API

#### 1. Recommended Recipe

| method | api      | reponse data                         |
| ------ | -------- | ------------------------------------ |
| GET    | /recipes | [id, subtitle, title, writer, image] |

#### 2. Get Recipe with 해먹남녀 URL

| method | api url  | request data   | response data                      |
| ------ | -------- | -------------- | ---------------------------------- |
| POST   | /recipes | url = "해먹남녀주소" | id, subtitle, title, writer, image |

#### 3. Get material with Recipe id

| method | api url                      | response data                            |
| ------ | ---------------------------- | ---------------------------------------- |
| GET    | /get_products/:id [레시피의 아이디] | [id, name, price, weight, bundle, image] |

#### 4. Get season recipe

| method | api url | response data                        |
| ------ | ------- | ------------------------------------ |
| GET    | /season | [id, subtitle, title, writer, image] |



## 모델

#### 1. Recipe [레시피]

id, subtitle, title, writer, image

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



