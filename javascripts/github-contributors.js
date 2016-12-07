// Pagination selector
var supporterPagination;

// Fetch Github contributors
var getContributors = function(url) {
  $.ajax(url)
    .done(function(contributors, statusCode, xhr) {
      var html = '';

      $.each(contributors, function(key, contributor) {
        html += '<div class="pure-u-1-6">';
        html += '<a href="' + contributor.html_url + '"><img src="' + contributor.avatar_url + '" alt="' + contributor.login + ' avatar"></a>';
        html += '</div>';
      });

      $("#supporters > div").html(html);

      var linksString = xhr.getResponseHeader('Link');
      var links = parseLinkHeader(linksString);

      // Check if the pagination was created or not
      if (supporterPagination === undefined) {
        pagination(links);
      }
    });
};

// Parse the Github link header
// Source: https://gist.github.com/niallo/3109252
var parseLinkHeader = function(header) {
  if (header.length == 0) {
    throw new Error("input must not be of zero length");
  }

  // Split parts by comma
  var parts = header.split(',');
  var links = {};
  // Parse each part into a named link
  _.each(parts, function(p) {
    var section = p.split(';');
    if (section.length != 2) {
      throw new Error("section could not be split on ';'");
    }
    var url = section[0].replace(/<(.*)>/, '$1').trim();
    var name = section[1].replace(/rel="(.*)"/, '$1').trim();
    links[name] = url;
  });

  return links;
};

// Create pagination
var pagination = function(links) {
  var lastIndex = links['last'].indexOf('?page=');
  var nextIndex = links['next'].indexOf('?page=');
  var lastNumber = links['last'].slice(lastIndex + 6);
  var nextNumber = links['next'].slice(nextIndex + 6);

  supporterPagination = $('#supporters__pagination');
  supporterPagination.twbsPagination({
    totalPages: lastNumber,
    visiblePages: 5,
    onPageClick: function(event, page) {
      $('#page-content').text('Page ' + page);
      getContributors('https://api.github.com/repos/RainbowEngineer/taiwan_love_wins/contributors?page=' + page);
    }
  });
}

getContributors("https://api.github.com/repos/RainbowEngineer/taiwan_love_wins/contributors");
