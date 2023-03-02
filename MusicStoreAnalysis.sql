----------------------------------------------- Music Store Data Analysis --------------------------------------------
select * from album
select * from artist
select * from customer
select * from employee
select * from genre
select * from invoice
select * from invoice_line
select * from media_type
select * from playlist
select * from playlist_track
select * from track

-- Find the total of invoice amount
select sum(total) from invoice

-- Who is the senior most employee based on job title ?
--                 select * from employee       
select employee_id,first_name,last_name,title,levels
from employee
order by(levels) desc
limit 1

-- Fetch track_id of top 3 no.of invoices per track 
select sum(quantity) invoices_per_track ,track_id
from invoice_line 
group by(track_id) 
order by invoices_per_track desc
limit 3;

-- Which countries have most invoices ? 
-- 			select * from invoice
select count(invoice_id) as no_of_invoices ,billing_country
from invoice
group by(billing_country)
order by no_of_invoices desc
--limit 1

--  Who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money.*/
-- 					select * from invoice  	
-- 					select * from customer  

select c.customer_id,first_name,last_name,sum(total) money_spent
from customer c 
join invoice i
on c.customer_id = i.customer_id
group by c.customer_id
order by money_spent desc
limit 1

-- Write a query to Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

			select * from track

select track_id,name,milliseconds
from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc

-- Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A. 

-------------------------------- Method 1 -----------------------
select email,first_name,last_name
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join genre g on t.genre_id = g.genre_id
where g.name ='Rock'
group by c.customer_id
order by email
-------------------------------- Method 2 ------------------------------
select distinct  email,first_name, last_name
From customer
Join invoice on customer.customer_id = invoice.customer_id
Join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
	select track_id From track
	Join genre on track.genre_id = genre.genre_id
	where genre.name LIKE 'Rock'
)
order by email;


-- Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals 
-- 					select * from invoice   
select billing_city, sum(total) invoice_Sum
from invoice
group by (billing_city)
order by invoice_Sum desc
limit 1

-- Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands.

-- 											select * from artist
-- 											select * from album
-- 											select * from track
-- 											select * from genre

select at.name,count(track_id) as no_of_rock_songs
from artist at 
join album ab on at.artist_id = ab.artist_id
join track t on ab.album_id = t.album_id
where track_id in (select track_id from track t
				  join genre g on g.genre_id = t.genre_id where g.name like 'Rock')
group by (at.name)
order by no_of_rock_songs desc
limit 10
---- &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- What are top 3 values of total invoice ?
-- 			select * from invoice
select total 
from invoice
order by total desc
limit 3










--- Note : The use of multiple joins is not optimized as it consumes processing time and data storing time making query time slow and hence CTE is used

/* We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1
select * from invoice_line

