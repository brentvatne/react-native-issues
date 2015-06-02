var React = require('react');
var request = require('superagent');

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

var App = React.createClass({
  getInitialState() {
    return {issues: null};
  },

  componentWillMount() {
    request.
      get('http://react-native-issues-api.herokuapp.com').
      end((err, result) => {
        if (!err) {
          this.setState({issues: result.body});
        } else {
          this.setState({error: true});
        }
      });
  },

  render() {
    if (this.state.issues) {
      return (
        <div>
          {this.state.issues.map((i) => <Issue value={i} />)}
        </div>
      )
    } else {
      return <h2>Loading...</h2>
    }
  }
});

module.exports = App;
