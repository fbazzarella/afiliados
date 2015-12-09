var parsePerc = function (partial, total) {
  return parseInt(partial / total * 100, 10);
};

var refreshProgress = function (progressBar, loaded, total) {
  var progress       = parsePerc(loaded, total),
      prettyProgress = progress + '%';

  progressBar.css('width', prettyProgress);

  if (progress > 0 && progress <= 100) {
    progressBar.text(prettyProgress);
  } else {
    progressBar.text('0%');
  };
};
