# Convert markdown to XML and HTML versions
docker run -v `pwd`:/data danielfett/markdown2rfc spec.md

# Delete XML version
rm *.xml

# Rename the HTML version for hosting with GH pages
mv openid-portable-identities-*.html index.html