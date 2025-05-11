create database music_database;

use  music_database;

show tables;

SELECT* FROM album2;

#1: Who is the senior most employee based on job title?

select* from employee;

select* from employee
ORDER BY levels desc
limit 1;

#2: Which countries have the most invoices?

select* from invoice;

select count(*) as c,billing_country
from invoice
GROUP BY billing_country
ORDER BY c desc;

#3: What are top 3 values of total invoices?

select* from invoice;

select* from invoice
ORDER BY total desc
limit 3;

#4: Which city has the best customers? We would like to throw a promotional music festival in the city we made the most money,
# write a query that returns one city that has the highest sum of invoice total.
#Return both the city name and sum of all invoice totals.


 
select* from invoice;

select billing_city,sum(total) as totals
from invoice
GROUP BY billing_city
ORDER BY totals desc
limit 1;


#5:Who is the best customer? The customer who has spent the most money will be declared the best customer.
#Write a query that returns the person who has spent the most money.

select* from customer;
select customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total) as total
from customer
INNER join invoice on customer.customer_id=invoice.customer_id
GROUP BY customer.customer_id,customer.first_name,customer.last_name
ORDER BY total desc
limit 1;

#6: Write query to return the email,firstname,last name,& genre of all rock music listeners.
# Return your list orderd alphabetically by email starting with A.

select* from customer;

select* from invoice;

select* from invoice_line;

select DISTINCT email,first_name,last_name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in (
select track_id from track
JOIN genre on track.genre_id=genre.genre_id
where genre.name like'rock'
)
ORDER BY email;

#7:Let's invite the artists who have written thr most rock music in our dataset.
# Write a query that returns the artist name and total track count of the top 10 rock bands.

SELECT artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
from track
join album2 on album2.album_id=track.album_id
JOIN artist on artist.artist_id=album2.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
GROUP BY artist.artist_id,artist.name
ORDER BY number_of_songs desc
limit 10;

#8: Return all the track names that have a song length longer than the average song length.
# Return the name and milliseconds for each track.
# orderby the song length with the longest song listed first.

select name,milliseconds 
from track
where milliseconds>(select avg(milliseconds) as avg_track_length
from track)
ORDER BY milliseconds desc;

#9: Find how much amount spent by each customer on artists? Write a query to return customer name,artist name and total spent.

with best_selling_artist as (
SELECT artist.artist_id as artist_id,artist.name as artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
from invoice_line
join track on track.track_id=invoice_line.track_id
join album2 on album2.album_id=track.album_id
join artist on artist.artist_id=album2.artist_id
GROUP BY artist_id,artist_name
ORDER BY total_sales desc
limit 1
)
select c.customer_id,c.first_name,c.last_name,bsa.artist_name,sum(il.unit_price*il.quantity) as amount_spent
from invoice as i
join customer as c on c.customer_id=i.customer_id
join invoice_line as il on il.invoice_id=i.invoice_id
join track as t on t.track_id=il.track_id
join album2 as alb on alb.album_id=t.album_id
join best_selling_artist as bsa on bsa.artist_id=alb.artist_id
GROUP BY c.customer_id,c.first_name,c.last_name,bsa.artist_name
ORDER BY amount_spent desc;

#10: WE want to find out the most popuar music genre for each country.
# We determine the most popular genre as the genre with the highest amount of purchases.
# Write a query that returns each country along with the top genre.For countries where the maximum number of purchases is shared returns all genres

with  popular_genre as(
select count(invoice_line.quantity) as purchases,customer.country,genre.name,genre.genre_id,
ROW_NUMBER()over(PARTITION BY customer.country ORDER BY count(invoice_line.quantity) desc) as rowno
from invoice_line 
join invoice on invoice.invoice_id=invoice_line.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
GROUP BY customer.country,genre.name,genre.genre_id
ORDER BY customer.country asc,purchases DESC
)
select* from popular_genre
where rowno<=1;




