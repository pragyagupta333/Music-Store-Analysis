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

-- Who is the senior most employee based on job title ?
--                 select * from employee
select employee_id,first_name,last_name,title,levels
from employee
order by(levels) desc
limit 1

-- Which countries have most invoices ?
-- 			select * from invoice
select count(invoice_id) as no_of_invoices ,billing_country
from invoice
group by(billing_country)
order by no_of_invoices desc
--limit 1

-- What are top 3 values of total invoice ?
-- 			select * from invoice
select total 
from invoice
order by total desc
limit 3

-- Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals 
-- 					select * from invoice
select billing_city, sum(total) invoice_Sum
from invoice
group by (billing_city)
order by invoice_Sum desc
limit 1

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


-- Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A.

-- Attempt :genre_id for rock music(name col) is 1 (genre table) genre_id --> track_id (track tb) --> 
-- invoice_id (invoice_line tb) --> invoice_id(invoice tb) customer_id --> customer tb
-- 										select * from genre
-- 										select * from invoice
-- 										select * from invoice_line
-- 										select * from track
-- 										select * from customer

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

-- Write a query to Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

-- 											select * from track

select name,milliseconds
from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc

--- Note : The use of multiple joins is not optimized as it consumes processing time and data storing time making query time slow

-- Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
