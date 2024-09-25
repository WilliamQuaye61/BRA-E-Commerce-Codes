Select *
From df_Payments$

--CLEANING PAYMENTS TABLE

Select payment_type,Upper(SUBSTRING(payment_type,1,1))
+ SUBSTRING(payment_type,2,LEN(payment_type))
From df_Payments$

Update df_Payments$
Set payment_type = Upper(SUBSTRING(payment_type,1,1))
+ SUBSTRING(payment_type,2,LEN(payment_type))

Update df_Payments$
Set payment_type = REPLACE(payment_type,'_',' ') 
From df_Payments$

-- REPLACING _ WITH SPACE i Product table
Select product_category_name,Upper(SUBSTRING(product_category_name,1,1))
+ SUBSTRING(product_category_name,2,LEN(product_category_name)) as cap_product_category  
from df_Products$

Update df_Products$
set product_category_name = Upper(SUBSTRING(product_category_name,1,1))
+ SUBSTRING(product_category_name,2,LEN(product_category_name))

Select REPLACE(product_category_name,'_',' ') 
From df_Products$


--CHECKING FOR DUPLICATES FOR EACH INDIVIDUAL TABLE

With dupCTE as(
Select *, ROW_NUMBER() over 
(Partition by customer_id order by customer_id) as row_num
From df_Customers$
)
Select *
From dupCTE
where row_num > 1


With dupCTE as(
Select *, ROW_NUMBER() over 
(Partition by order_id,
              product_id,
			  seller_id,
			  price,
			  shipping_charges
			  order by product_id) as row_num
From df_OrderItems$
)
Select *
From dupCTE
where row_num > 1

With dupCTE as(
Select *, ROW_NUMBER() over 
(Partition by customer_id,
			  order_id
			  order by customer_id) as row_num
From df_Orders$
)
Select *
From dupCTE
where row_num > 1

--Payemnt had duplicates
With dupCTE as(
Select *, ROW_NUMBER() over 
(Partition by order_id,	
              payment_sequential,
			  payment_type,
			  payment_installments,
			  payment_value
			  order by order_id) as row_num
From df_Payments$
)
Select *
From dupCTE

With dupCTE as(
Select *, ROW_NUMBER() over 
(Partition by product_id,	
              product_category_name,
			  product_weight_g,
			  product_length_cm,
			  product_height_cm,
			  product_width_cm
			  order by product_id) as row_num
From df_Products$
)
Select *
From dupCTE


With dupCTE as(
Select *, ROW_NUMBER() over 
(Partition by product_id,	
              product_category_name,
			  product_weight_g,
			  product_length_cm,
			  product_height_cm,
			  product_width_cm
			  order by product_id) as row_num b
From df_Products$
)
Delete
From dupCTE
where row_num > 1

Select *
From df_Customers$ C
Join df_Orders$ O
On C.customer_id = O.customer_id
Join df_OrderItems$ OI
on O.order_id = OI.order_id
Join df_Products$ Pr
On OI.product_id = Pr.product_id
Join df_Payments$ Pa
On O.order_id = Pa.order_id





