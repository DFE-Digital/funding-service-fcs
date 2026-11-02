Feature: PerformancePublishApprovedContract
I want to proove tha the contract publish webservice is capable of 
performing at production load levels with 
1)each request responding within 2 seconds
2)It can support 10 threads, 

#marking as in progress to just do bulk import
#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P020 Execute 50 published contract requests in less than 100 seconds 
	Given a timer is started
	When  the 'approvals' link is retrieved 50 times
	Then  the timer should be less than 100 seconds

