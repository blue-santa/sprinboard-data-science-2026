# Relax Inc - Overall Findings

The client provided two datasets and requested a data analysis looking for insights about how a user comes to be an "adopted user", which is defined as a user that has logged in at least three times during any seven-day period.

I first inspected the data with a focus on the time-based elements. One derived metric that I determined to be worth  including was the duration between the time a user created their account and their last created login. Using custom code, I ascertained the users that fit the criteria for an `adopted user` and categorized them.

Another important derived metric was the `invited_by_user_id` column. As an experiment, I tried creating columns that showed the number of times a user invited someone, as well as the invite-activity rate of the person who did the inviting. Neither of these columns showed high levels of correlation with the `adopted_user` metric.

Using Scikit-Learn's `mutual_info_score` tool, I measured the categorical columns in the provided datasets. Interestingly, this revealed that the `invited_by_user_id` column held an approximate `0.10` correlation score. This was the highest score of the correlation scores, outside of overall activity duration.

This would suggest that the person who does the inviting is, perhaps, the most influential factor in whether or not a new user will become a permanent part of the community. Relax Inc. may wish to continue research into these highly effective inviters and perhaps perform a dedicated outreach and retention track for them.

The analysis process concluded with using Scikit-Learn's `LinearRegression` model to determine predictability. 

When the overall activity duration was included as a metric, the model could predict a user's likelihood of becoming an adopted user with an R2 score of `0.77`. However, because of the strong relationship between overall activity and adopted-user status, I removed the overall activity metric and reran the experiment. The resulting R2 score was `0.41`. This suggests that there is some level of prediction that can be found among new users and those who will reach the adopted-user status, but the level of accuracy is limited. 