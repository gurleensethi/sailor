import 'package:sailor/src/url_parser/url_tree.dart';
import 'package:test/test.dart';

void main() {
  late UrlTree<String> _tree;

  setUp(() {
    _tree = UrlTree<String>('/');
  });

  test('stores a simple url', () {
    final String url = '/magic/';
    _tree.addUrl(url, 'magic');
    expect(_tree.root.children.containsKey('magic'), isTrue);
  });

  test('stores 2 urls with same root', () {
    final String url1 = '/magic/1';
    final String url2 = '/magic/2';
    _tree.addUrl(url1, '1');
    _tree.addUrl(url2, '2');
    expect(_tree.root.children.containsKey('magic'), isTrue);
    expect(_tree.root.children['magic']!.children.containsKey('1'), isTrue);
    expect(_tree.root.children['magic']!.children.containsKey('2'), isTrue);
  });

  test('stores 2 urls with same different roots', () {
    final String url1 = '/abc/1';
    final String url2 = '/def/2';
    _tree.addUrl(url1, 'abc');
    _tree.addUrl(url2, 'def');
    expect(_tree.root.children['abc']!.children.containsKey('1'), isTrue);
    expect(_tree.root.children['def']!.children.containsKey('2'), isTrue);
  });

  test('stores parameter url', () {
    final String url = "/user/:id";
    _tree.addUrl(url, '123');
    expect(_tree.root.children.containsKey('user'), isTrue);
    expect(_tree.root.children['user']!.children['id']!.value, equals("123"));
  });

  test('testing', () {
    final String url1 = "/magic/1";
    final String url2 = "/magic/";
    _tree.addUrl(url1, "1");
    expect(_tree.root.children['magic']!.value, isNull);
    _tree.addUrl(url2, "2");
    expect(_tree.root.children['magic']!.value, equals("2"));
    expect(_tree.root.children['magic']!.children["1"]!.value, equals("1"));
  });

  test('find matches url', () {
    final String url = '/magic/';
    _tree.addUrl(url, '123');
    expect(_tree.find('magic'), equals('123'));
  });

  test('find matches urls with same root', () {
    final String url1 = '/magic/1';
    final String url2 = '/magic/2';
    _tree.addUrl(url1, '1');
    _tree.addUrl(url2, '2');
    expect(_tree.find('magic/1'), '1');
    expect(_tree.find('magic/2'), '2');
  });

  test('find matches urls with same root and different lengths', () {
    final String url1 = '/user/1/projects';
    final String url2 = '/user/1';
    _tree.addUrl(url1, '1');
    _tree.addUrl(url2, '2');
    expect(_tree.find('user/1/projects'), '1');
    expect(_tree.find('user/1'), '2');
  });

  test('find matches urls with different root and different lengths', () {
    final String url1 = '/user/1/projects';
    final String url2 = '/admin/1';
    _tree.addUrl(url1, '1');
    _tree.addUrl(url2, '2');
    expect(_tree.find('user/1/projects'), '1');
    expect(_tree.find('admin/1'), '2');
  });

  test('find matches simple url with parameter', () {
    final String url = '/magic/:id';
    _tree.addUrl(url, '123');
    expect(_tree.find('magic/10'), equals('123'));
  });

  test('find matches url with parameter', () {
    final String url = '/user/:id/project';
    _tree.addUrl(url, '123');
    expect(_tree.find('user/10/project'), equals('123'));
  });

  test('find matches url with parameter with same root', () {
    final String url1 = '/user/project/:id';
    final String url2 = '/user/task/:id';
    _tree.addUrl(url1, '1');
    _tree.addUrl(url2, '2');
    expect(_tree.find('user/project/100'), '1');
    expect(_tree.find('user/task/10'), '2');
  });

  test('find matches url with parameter with same root and different endings',
      () {
    final String url1 = '/user/:id/project';
    final String url2 = '/user/:id/task';
    _tree.addUrl(url1, '1');
    _tree.addUrl(url2, '2');
    expect(_tree.find('user/100/project/'), '1');
    expect(_tree.find('user/100/task/'), '2');
  });

  test(
      'find matches url with parameter with same root and '
      'different endings with different length', () {
    final String url1 = '/user/:id/task/';
    final String url2 = '/user/:id/task/completed';
    _tree.addUrl(url1, '1');
    _tree.addUrl(url2, '2');
    expect(_tree.find('user/100/task/'), '1');
    expect(_tree.find('user/100/task/completed'), '2');
  });

  test(
      'find matches url with parameter with same root and '
      'different parameter endings with different length', () {
    final String url1 = '/user/:id/task/';
    final String url2 = '/user/:id/task/:id';
    _tree.addUrl(url1, '1');
    _tree.addUrl(url2, '2');
    expect(_tree.find('user/100/task/'), '1');
    expect(_tree.find('user/100/task/100'), '2');
  });
}
