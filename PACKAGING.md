# Validation

Ensure that following commands returns `No rule violations found`. At the time of writing both commands did not produce output files if no violations found.

[Those steps are now requirement for submitting package for security review.
](https://developer.salesforce.com/docs/atlas.en-us.packagingGuide.meta/packagingGuide/security_review_code_analyzer_scan.htm)
1. ```sf scanner run -f xml -o CodeAnalyzerGeneral.xml -t . -c Security```
2. ```sf scanner run dfa -f csv -o CodeAnalyzerDFA.csv -t . -p . -c Security```

# Packaging
