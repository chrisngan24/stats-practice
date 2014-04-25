import sys
from feature import ContinuousFeature, DiscreteFeature, FeatureCollection, FeatureType
from sklearn.feature_extraction import DictVectorizer
from sklearn.naive_bayes import GaussianNB
gnb = GaussianNB()
vec = DictVectorizer()
"""
Extrats data set from given path to array of hashes
where keys are set from order array and value is 
value of dataset
"""
def extract_dataset(path, order, config, skip_first_line=False):
    f = open(path, 'r')
    raw = f.read().split('\n')
    if skip_first_line:
        raw.pop(0)
    data = [] 
    for row in raw:
        if row != '':
            item = {}
            values = row.split(',')
            for i in range(0, len(order)):
                item[order[i]] = values[i].strip()

                if config[order[i]] == 'continuous':
                    item[order[i]] = float(values[i].strip())

            data.append(item)
    return data



"""
Returns hash where key is field and value is continuous 
or discrete and array that contains the keys in order
of expected appearance in dataset
"""
def extract_config_and_order(path):
    data = open(path, 'r').read().split('\n')
    config = {}
    order = [] 
    for line in data:
        a = line.split(',')
        if len(a) ==2:
            config[a[0].strip()] = a[1].strip()
            order.append(a[0].strip())
    return [config, order]

def generate_feature_collection(training_data, config):
    feat_coll = FeatureCollection()
    for row in training_data:
        for feat_name in row.keys():
            if feat_name != 'class':
                feat_type = FeatureType.continuous if config[feat_name] == 'continuous' else FeatureType.discrete
                feat_coll.add_feature(
                    row[feat_name],
                    feat_name,
                    feat_type,
                    row['class'])
    return feat_coll

def predict(feat_coll, test_data):
    predictions = []
    correct = 0
    wrong = 0

    for data in test_data:
        prediction, stats = feat_coll.predict(data)
        actual = data['class']
        if actual == prediction:
            correct += 1
        else:
            wrong += 1
        predictions.append({
            'prediction' : prediction,
            'actual' : actual,
            'stats' : stats,
            'same' : True if actual == prediction else False}) 

    total = float(correct + wrong)
    print '%s of predictions were correct' % str(float(correct)/total)
    print '%s of predictions were wrong' % str(float(wrong)/total)
    return predictions


def main():
    if len(sys.argv) != 4:
        print 'missing arguements! require training set and test set'
        exit()
    training_file_name, test_file_name, data_config_name = [sys.argv[1], sys.argv[2], sys.argv[3]]
    config, order = extract_config_and_order(data_config_name)

    training_data =  extract_dataset(training_file_name, order,config,  skip_first_line=True)
    feat_coll = generate_feature_collection(training_data, config)
    training_vector = vec.fit_transform(training_data, y='class')

    feat_coll.train()
    test_data =  extract_dataset(test_file_name, order, config, skip_first_line=True)

    test_vector = vec.fit_transform(test_data, y='class')

    predictions = predict(feat_coll, test_data) 

     

if __name__=="__main__":
    main()
