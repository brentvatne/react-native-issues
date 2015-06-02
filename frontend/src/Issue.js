var React = require('react');

var Issue = React.createClass({
  render() {
    var { id, title, url, number, } = this.props.value;

    return (
      <p key={id}>
        <a href={'https://github.com/facebook/react-native/issues/' + number} target="_blank">
          {title}
        </a>
      </p>
    )
  },
});

module.exports = Issue;
