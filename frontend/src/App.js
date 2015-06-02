var React = require('react');
var request = require('superagent');
var { Treemap, BarChart, } = require('react-d3');
var _ = require('lodash');

var App = React.createClass({
  getInitialState() {
    return {tags: null};
  },

  componentWillMount() {
    request.
      get('http://react-native-issues-api.herokuapp.com/tag-counts').
      end((err, result) => {
        if (!err) {
          this.setState({tags: result.body});
        } else {
          this.setState({error: true});
        }
      });
  },

  render() {
    if (this.state.tags) {
      var data = _.map(this.state.tags, (count, tag) => {
        return {label: tag, value: count};
      });

      data = _.filter(data, (datum) => {
        return datum.value > 1;
      });

      return (
        <div>
          <BarChart
            data={data}
            width={1200}
            height={400}
            fill={'#3182bd'}
            title='Issue Distribution' />

          <Treemap
            data={data}
            width={1200}
            height={400}
            textColor="#484848"
            fontSize="10px"
            title="Treemap" />
        </div>
      )
    } else {
      return <h2>Loading...</h2>
    }
  }
});

module.exports = App;
