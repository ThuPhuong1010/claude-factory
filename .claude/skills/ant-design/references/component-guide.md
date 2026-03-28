# Ant Design Component Deep Guide

## Form Pattern
const [form] = Form.useForm();
onFinish handler → gọi mutation → message.success → reset
Form.Item với rules array cho validation
Button htmlType="submit" loading={mutation.isPending}

## Table Pattern
columns config riêng file
Pagination controlled
Search/filter update query params

## Modal Confirm
Modal.confirm({ title, content, okText, okType: 'danger', onOk })
