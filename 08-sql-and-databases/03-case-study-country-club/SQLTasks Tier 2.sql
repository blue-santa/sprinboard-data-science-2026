/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name FROM Facilities where membercost != 0;


/* Q2: How many facilities do not charge a fee to members? */

SELECT count(*) FROM Facilities where membercost != 0;

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance FROM Facilities where membercost < monthlymaintenance * 0.2;

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT * FROM Facilities where facid in (1, 5);

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

select 
	name,
    monthlymaintenance,
    case
    	when monthlymaintenance > 100 then 'expensive'
        when monthlymaintenance <= 100 then 'cheap'
        else 'unknown'
    end as 'costliness'
from Facilities;

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

select firstname, surname, joindate from Members where joindate = (select max(joindate) from Members);

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

select
	unique(concat(m.firstname, ' ', m.surname, ', ', f.name)) as Member_Facility_List
from Bookings as b
left join Members as m on b.memid = m.memid
left join Facilities as f on b.facid = f.facid
where m.memid != 0 AND
f.name like '%Tennis Court%'
order by Member_Facility_List;

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

select
	f.name,
    concat(m.firstname, ' ', m.surname) as Member_Name,
    case
        when b.memid  = 0 then (f.guestcost * b.slots)
        when b.memid != 0 then (f.membercost * b.slots)
    end as cost
from Bookings as b
left join Facilities as f on b.facid = f.facid
left join Members as m on b.memid = m.memid
where
	b.starttime like '%2012-09-14%' AND
  	(case
        when b.memid  = 0 then (f.guestcost * b.slots)
        when b.memid != 0 then (f.membercost * b.slots)
    end) > 30
order by cost desc;

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

with cost as ( 
	select
    	b.bookid,
	    case
            when b.memid  = 0 then (f.guestcost * b.slots)
            when b.memid != 0 then (f.membercost * b.slots)
    	end as cost
    from Bookings as b
    left join Facilities as f on b.facid = f.facid
)
select 
	f.name,
    concat(m.firstname, ' ', m.surname) as Member_Name, 
	c.cost
from Bookings as b
left join Facilities as f on b.facid = f.facid
left join Members as m on b.memid = m.memid
left join cost as c on b.bookid = c.bookid
where 
	b.starttime like '%2012-09-14%' AND
  	c.cost > 30
order by c.cost desc;

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  
*/

bookings = pd.read_sql_table('bookings', con=engine)
facilities = pd.read_sql_table('facilities', con=engine)
members = pd.read_sql_table('members', con=engine)

/*
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

query = """
with revenue as (
	select
		b.bookid,
		case
			when b.memid  = 0 then (f.guestcost * b.slots)
			when b.memid != 0 then (f.membercost * b.slots)
		end as session_earning
	from bookings as b
	left join facilities as f on b.facid = f.facid
),
run_tot as (select
	f.name as fac_name,
	sum(r.session_earning) as tot_rev
from facilities as f
left join bookings as b on b.facid = f.facid
left join revenue as r on r.bookid = b.bookid
group by f.name
order by tot_rev desc)
select
	rt.fac_name,
	rt.tot_rev
from run_tot as rt
where rt.tot_rev < 1000;
"""

revenue = pd.read_sql_query(query, engine)

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


/* Q12: Find the facilities with their usage by member, but not guests */


/* Q13: Find the facilities usage by month, but not guests */

